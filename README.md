# Complete Dockerized Sixpack a/b testing server
This repository helps building your own [Sixpack](sixpack.seatgeek.com) a/b testing server in a complete dockerized solution.  
Main features are:
- Seperate containers for the Sixpack API servers and the web dashboard
- Support for one or more Sixpack API servers
- nginx HTTPS proxy for both API and web dashboard
- Generate a self-signed certificate or replace with your own CA signed certificate
- Support web dashboard basic authentication login

It contains the following containers:
- `sixpack-nginx1` - The HTTPS nginx proxy which that servers the sixpack API server and web dashboard. It enables load balancing between the sixpack servers and basic authentication for the web dashboard.
- `sixpack-server1..n` - One or more sixpack API servers
- `sixpack-web1` - The sixpack web dashboard
- `sixpack-redis1` - The redis server

You can find the docker images on our Docker Hub repository: https://hub.docker.com/r/baloota/

## Usage
### First time setup
Clone the repository:  
`git clone https://github.com/baloota/sixpack-complete.git`  
Build the environment:  
`./build.sh`

1. **Enter the sixpack server URL:**  
Just enter the URL you plan to host your sixpack server on.   
(It could be `localhost` for testing purposes)  

2. **How many sixpack server containers do you want to start? [1]**  
You could run one or more sixpack API servers that will be load balanced by nginx.  
(You could just press `<ENTER>` which will create a single container)  

3. **Enter the user name for sixpack admin:**  
Choose a user name for the web dashboard admin basic authentication  
Then you need to enter a password for that user  

4. **Creating a self signed certificate...**  
Create a self signed certificate for the nginx HTTPS port.  
You could afterwards replace the `nginx/build/private.key` and `nginx/build/public.crt` with a CA signed certificate

5. **Docker run**  
Now the build script will create the containers and run them on the docker machine.

### Check server
After completing the setup, you should check the server is running by entering the web dashboard: `https://<SIXPACK_URL>/`

### Start the sixpack server
`./start.sh`

### Stop the sixpack server
`./stop.sh`

### Remove the containers
`./remove.sh`  
`./remove.sh redis` - Remove the redis server too (**and ALL its data**)

### Reset the environment
`./reset.sh`  
`./reset.sh cert` - **NOTE**: will also delete the certificates

This will reset the configuration which was created running the build script. It actually deletes the `nginx/build` folder and `.buildenv` configuration script.