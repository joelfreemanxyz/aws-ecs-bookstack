#!/usr/bin/env python3

from flask import Flask, request
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

from app.resources.dog import dogById
from app.resources.healthcheck import healthCheck

app = Flask(__name__)
api = Api(app)
CORS(app)


# endpoints
api.add_resource(healthCheck, '/health')
api.add_resource(dogById, '/dog/<string:dog_id>')

if __name__ == '__main__':
    app.run(debug=True)