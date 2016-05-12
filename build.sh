docker build -t sixpack-server:0.2 server
docker build -t sixpack-web:0.2 web
docker build -t sixpack-nginx:0.1 nginx

docker rm sixpack-server1
docker rm sixpack-web1
docker rm sixpack-nginx1

docker ps -a | grep sixpack-redis1 > /dev/null
if [ $? -eq 0 ]; then
	docker start sixpack-redis1	
else
	docker run --name sixpack-redis1 -d redis:alpine
fi

docker run -d --link sixpack-redis1 --name sixpack-server1 sixpack-server:0.2
docker run -d --link sixpack-redis1 --name sixpack-web1 sixpack-web:0.2
docker run -d --link sixpack-server1 --link sixpack-web1 --name sixpack-nginx1 -p 443:443 -p 80:80 sixpack-nginx:0.1