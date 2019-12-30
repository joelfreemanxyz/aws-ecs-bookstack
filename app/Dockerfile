FROM python:alpine

RUN mkdir /app
WORKDIR /app
COPY src/. /app/
RUN pip install -r requirements.txt
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
