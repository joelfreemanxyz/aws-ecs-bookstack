FROM python:alpine

COPY . /app
WORKDIR /app

# disable creation of __pycache__ and such
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies for psyopg2
RUN apk update && \
    apk add --virtual build-deps gcc python-dev musl-dev && \
    apk add postgresql-dev

# install requirements 
RUN pip install -r requirements.txt

EXPOSE 5000
ENTRYPOINT [ "./entrypoint.sh"]
