ls .buildenv &> /dev/null
if [ $? -ne 0 ]; then
	echo "Error: Sixpack environment not initialized"
	echo "Please run build.sh first"
	exit 8
fi
source .buildenv

docker rm sixpack-web1
for (( i=1; i<=$SIXPACK_SERVERS; i++ )); do
	echo "docker rm sixpack-server$i" | bash
done
docker rm sixpack-nginx1
if [ "$1" == "redis" ]; then
	docker rm sixpack-redis1
fi