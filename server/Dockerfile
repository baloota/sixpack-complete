FROM python:2.7-onbuild
MAINTAINER Alik hochner <alikh@baloota.com>

ENV SIXPACK_CONFIG_REDIS_HOST sixpack-redis1

EXPOSE 5000
CMD ["gunicorn", "sixpack.server:start", "--bind", "0.0.0.0:5000", "-w", "8", "--access-logfile", "-", "--worker-class=gevent"]
