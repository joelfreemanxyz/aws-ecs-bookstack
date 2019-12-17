FROM python:alpine

EXPOSE 5000
WORKDIR /app
COPY ./src /app
RUN pip install -r requirements.txt
ENTRYPOINT [ "python", "app.py" ]
