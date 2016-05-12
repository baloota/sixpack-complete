# Based on: https://docs.docker.com/machine/drivers/gce/

echo "Choose project dumpster-ab"
gcloud init

docker-machine create --driver google \
  --google-project dumpster-ab \
  --google-zone europe-west1-d \
  --google-machine-type n1-standard-1 \
  docker-t-vm01

docker-machine env docker-t-vm01
eval $(docker-machine env docker-t-vm01)

./build.sh
