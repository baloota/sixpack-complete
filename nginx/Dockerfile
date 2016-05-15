FROM nginx:stable-alpine
RUN rm -v /etc/nginx/conf.d/default.conf
COPY build/sixpack.conf /etc/nginx/conf.d/sixpack.conf
COPY certs/* /etc/nginx/certs/
COPY build/htpasswd /etc/nginx/.htpasswd
EXPOSE 443
