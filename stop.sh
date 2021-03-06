ls .buildenv &> /dev/null
if [ $? -ne 0 ]; then
	echo "Error: Sixpack environment not initialized"
	echo "Please run build.sh first"
	exit 8
fi
source .buildenv

docker stop sixpack-nginx1
docker stop sixpack-web1
for (( i=1; i<=$SIXPACK_SERVERS; i++ )); do
	echo "docker stop sixpack-server$i" | bash
done
docker stop sixpack-redis1