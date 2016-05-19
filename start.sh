ls .buildenv &> /dev/null
if [ $? -ne 0 ]; then
	echo "Error: Sixpack environment not initialized"
	echo "Please run build.sh first"
	exit 8
fi
source .buildenv

docker start sixpack-redis1
docker start sixpack-web1
for (( i=1; i<=$SIXPACK_SERVERS; i++ )); do
	echo "docker start sixpack-server$i" | bash
done
docker start sixpack-nginx1