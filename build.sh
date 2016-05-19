if [ -z "$DOCKER_MACHINE_NAME" ]; then
	echo "Please connect to docker machine:"
	echo "eval \`docker-machine env\`"
	exit 8
fi
## Check if the build environment variables are set
ls .buildenv &> /dev/null
if [ $? -ne 0 ]; then
	echo "Enter the sixpack server URL:"
	read url
	echo "export SIXPACK_URL=$url" > .buildenv
	echo "export SIXPACK_CONFIG_SECRET=`openssl rand -base64 32 | sed ""s/[+=\/:]//g""`" >> .buildenv
	echo "How many sixpack server containers do you want to start? [1]"
	read servers
	if [ -z "$servers" ]; then
		servers=1
	fi
	echo "export SIXPACK_SERVERS=$servers" >> .buildenv

	for (( i=1; i<=$servers; i++ )); do
		linkparam="$linkparam --link sixpack-server$i";
	done
	echo "export SIXPACK_SERVERS_NGINX_LINK=\"$linkparam\"" >> .buildenv

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

	for (( i=1; i<=$SIXPACK_SERVERS; i++ )); do
		upstream="$upstream server sixpack-server$i:5000;";
	done
	sed -i -e "s/##SIXPACK_SERVER_UPSTREAM##/$upstream/g" nginx/build/sixpack.conf
fi

ls nginx/build/htpasswd &> /dev/null
if [ $? -ne 0 ]; then
	echo "Enter the user name for sixpack admin:"
	read username
	echo -n "$username:" > nginx/build/htpasswd
	openssl passwd -apr1 >> nginx/build/htpasswd
fi

## Check for SSL certificates
ls nginx/certs/ &> /dev/null
if [ $? -ne 0 ]; then
	mkdir nginx/certs
fi

ls nginx/certs/*.crt &> /dev/null
if [ $? -ne 0 ]; then
	echo "creating a self signed certificate (you can replace these with a CA signed certificate later)"
	openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -keyout nginx/certs/private.key -out nginx/certs/public.crt
fi

docker build -t sixpack-nginx nginx

docker ps -a | grep sixpack-redis1 > /dev/null
if [ $? -eq 0 ]; then
	docker start sixpack-redis1	
else
	docker run --name sixpack-redis1 -d redis:alpine redis-server --appendonly yes
fi

for (( i=1; i<=$SIXPACK_SERVERS; i++ )); do
	echo "docker run -d --link sixpack-redis1 --name sixpack-server$i baloota/sixpack-server" | bash
done

docker run -d --link sixpack-redis1 --name sixpack-web1 --env SIXPACK_CONFIG_SECRET=$SIXPACK_CONFIG_SECRET baloota/sixpack-web
echo "docker run -d $SIXPACK_SERVERS_NGINX_LINK --link sixpack-web1 --name sixpack-nginx1 -p 443:443 -p 80:80 sixpack-nginx" | bash