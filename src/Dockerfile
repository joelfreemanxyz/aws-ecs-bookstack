FROM python:alpine
WORKDIR /src
COPY . /src
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT [ "./entrypoint.sh"]
