#!/usr/bin/env python3

from flask import Flask, request
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import exc
from os import environ 
import config, logging
from logging.handlers import RotatingFileHandler

app = Flask(__name__)

try:
    print(environ['CONFIG'])
except KeyError:
    message = "Expected environment variable 'CONFIG' not set."
    raise Exception(message)

app.config.from_object('config.{}'.format(environ['CONFIG']))
api = Api(app, catch_all_404s=True)
db = SQLAlchemy(app)

# logging

# model
class Dog(db.Model):
    __tablename__ = 'dog'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    age = db.Column(db.Integer)
    color = db.Column(db.String(255))

    #def __repr__(self):
    #   return '<Dog (id=%d, name=%s, age=%d, color=%s)>' % (
    #        self.id, self.name, self.age, self.color 
    #)

# routes
class dogById(Resource):
    def get(self, dog_id):
        query = Dog.query.filter_by(id=dog_id).first()
        return {
            'id': query.id,
            'name': query.name,
            'age': query.age,
            'color': query.color,
        }

    def delete(self, dog_id):
        dog = db.Dog.query.get(dog_id)
        db.session.delete(dog)
        db.session.commit()

    # update existing resource 
    def put(self, dog_id):
        dog_name = request.args.get('name')
        dog_age = request.args.get('age')
        dog_color = request.args.get('color')
        try:
            newDog = Dog(id=dog_id, name=dog_name, age=dog_age, color=dog_color)
            db.session.add(newDog)
            db.session.commit()
        except psycopg2.erors.UniqueViolation:
            return {'ID ALREADY EXISTS'}

        return {
            'id': dog_id,
            'name': newDog.name,
            'age': newDog.age,
            'color': newDog.color
        }
 
class healthCheck(Resource):
    def get(self):
        return {'OK'}, 200

# endpoints
api.add_resource(healthCheck, '/health')
api.add_resource(dogById, '/dog/<int:dog_id>')

if __name__ == '__main__':
    log_handler = RotatingFileHandler('app.log', maxBytes=100000, backupCount=10)
    log_handler.setLevel(logging.INFO)
    app.run(
        host="0.0.0.0",
        port=5000
    )