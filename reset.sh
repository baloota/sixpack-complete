echo "This resets all environment configuration (INCLUDING SSL CERTIFICATES and HTTPASSWD)\nPress any to continue or break to cancel"
read
rm .buildenv 
rm -R nginx/build
rm nginx/certs/*
