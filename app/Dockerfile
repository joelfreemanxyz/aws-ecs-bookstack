FROM python:alpine
COPY . /ecs-app
WORKDIR /ecs-app
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT [ "./entrypoint.sh"]
