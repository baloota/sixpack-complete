FROM python:2.7-onbuild
MAINTAINER Alik hochner <alikh@baloota.com>

ENV SIXPACK_CONFIG_REDIS_HOST sixpack-redis1
ENV SIXPACK_CONFIG_SECRET asdfasdfasdf

EXPOSE 5001
CMD ["gunicorn", "sixpack.web:start", "--bind", "0.0.0.0:5001", "-w", "2", "--access-logfile", "-", "--worker-class=gevent"]
