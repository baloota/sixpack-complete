docker build -t sixpack-server:0.1 server
docker build -t sixpack-web:0.1 web

docker rm sixpack-server1
docker rm sixpack-web1

docker run -d -p 5000:5000 --link sixpack-redis1 --name sixpack-server1 sixpack-server:0.1
docker run -d -p 5001:5001 --link sixpack-redis1 --name sixpack-web1 sixpack-web:0.1

## In case you want to rebuild the redis server - WILL DELETE ITS DATA
# docker rm sixpack-redis1
# docker run --name sixpack-redis1 -d redis:alpine 
