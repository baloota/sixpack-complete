docker-machine ls

## Check if the build environment variables are set
ls .buildenv &> /dev/null
if [ $? -ne 0 ]; then
	echo "Enter the sixpack server URL:"
	read url
	echo "export SIXPACK_URL=$url" > .buildenv
	chmod +x .buildenv
fi
source .buildenv

## nginx configuration
ls nginx/build/ &> /dev/null
if [ $? -ne 0 ]; then
	mkdir nginx/build
fi

ls nginx/build/sixpack.conf &> /dev/null
if [ $? -ne 0 ]; then
	cp nginx/sixpack.conf.template nginx/build/sixpack.conf
	sed -i -e "s/##SERVER_NAME##/$SIXPACK_URL/g" nginx/build/sixpack.conf
fi

ls nginx/build/htpasswd &> /dev/null
if [ $? -ne 0 ]; then
	echo "Enter the user name for sixpack admin:"
	read username
	echo -n "$username:" > nginx/build/htpasswd
	openssl passwd -apr1 >> nginx/build/htpasswd
fi

## Check for SSL certificates
ls nginx/certs/*.crt &> /dev/null
if [ $? -ne 0 ]; then
	echo "creating a self signed certificate"
	openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -keyout nginx/certs/private.key -out nginx/certs/public.crt
fi

docker build -t sixpack-server:1.0 server
docker build -t sixpack-web:1.0 web
docker build -t sixpack-nginx:1.0 nginx

docker rm sixpack-server1
docker rm sixpack-server2
docker rm sixpack-web1
docker rm sixpack-nginx1

docker ps -a | grep sixpack-redis1 > /dev/null
if [ $? -eq 0 ]; then
	docker start sixpack-redis1	
else
	docker run --name sixpack-redis1 -d redis:alpine redis-server --appendonly yes
fi
docker run -d --link sixpack-redis1 --name sixpack-server1 sixpack-server:1.0
docker run -d --link sixpack-redis1 --name sixpack-server2 sixpack-server:1.0
docker run -d --link sixpack-redis1 --name sixpack-web1 sixpack-web:1.0
docker run -d --link sixpack-server1 --link sixpack-server2 --link sixpack-web1 --name sixpack-nginx1 -p 443:443 -p 80:80 sixpack-nginx:1.0

## NOTES:
## To create a docker machine on google cloud platform:
## https://docs.docker.com/machine/drivers/gce/