echo "This will resets environment configuration"
echo "Press any to continue or break to cancel"
read
rm .buildenv 
rm -R nginx/build

if [ "$1" == "cert" ]; then
	echo
	echo "Are you SURE you want to delete the certificates?"
	echo "Press any to continue or break to cancel"
	read
	rm nginx/certs/*
fi