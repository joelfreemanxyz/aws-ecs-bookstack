FROM python:alpine

RUN mkdir /app
WORKDIR /app
COPY image/. /app/
RUN chmod +x docker-entrypoint.sh
RUN pip install setuptools
RUN pip install .
RUN apk add --no-cache curl
ENTRYPOINT [ "./docker-entrypoint.sh" ]
