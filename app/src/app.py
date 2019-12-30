#!/usr/bin/env python3

from flask import Flask
import socket

def create_app():
    app = Flask(__name__)

    @app.route("/")
    def hello_world():
        return "Hello from container {}!".format(socket.gethostname())

    @app.route("/health")
    def health_check():
        return "all good!"
     
    return app
