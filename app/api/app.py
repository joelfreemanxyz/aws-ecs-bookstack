#!/usr/bin/env python3

from flask import Flask, request
from flask_restful import Resource, Api, reqparse, abort
from flask_sqlalchemy import SQLAlchemy
from os import environ

try:
    print(environ['CONFIG'])
    print(environ['CREATE_DB'])
except KeyError:
    message = "Expected environment variable 'CONFIG' not set."
    raise Exception(message)


app = Flask(__name__)
api = Api(app, catch_all_404s=True)
db = SQLAlchemy(app)

app.config.from_object('config.{}'.format(environ['CONFIG']))

parser = reqparse.RequestParser()
parser.add_argument('name', type=str, location='args')
parser.add_argument('age', type=int, location='args')
parser.add_argument('color', type=str, location='args')

class Dog(db.Model):
    __tablename__ = 'dogs'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    age = db.Column(db.Integer)
    color = db.Column(db.String(255))

    def __repr__(self):
        return '<dog (id=%d, name=%s, age=%d, color=%s)>' %(
            self.id, self.name, self.age,self.color
        )
def abort_if_dog_not_exist(dog_id):
    try:
        dog_list = Dog.query.filter_by(id=dog_id).first()
        if dog_id not in dog_list:
            abort(404, message="Dog #{} does not exist.".format(dog_id))
    except Exception as e:
        error = str(e)
        return {
            'an error occured': error
        }, 500
        
class dogById(Resource):
    def get(self, dog_id):
        abort_if_dog_not_exist(dog_id)
        query = Dog.query.filter_by(id=dog_id).first()
        return {
            'id': query.id,
            'name': query.name,
            'age': query.age,
            'color': query.color,
        }, 200

    def delete(self, dog_id):
        Dog.abort_if_dog_not_exist(dog_id)
        dog = Dog.query.get(dog_id)
        db.session.delete(dog)
        
        return {
        }, 204


    def put(self, dog_id):
        # get args
        parser.replace_argument('name', type=str, location='args', required=True)
        parser.add_argument('age', type=int, location='args', required=True)
        parser.add_argument('color', type=str, location='args', required=True)
        args = parser.parse_args()

        # check if resource exists
        query = Dog.query.filter_by().first()
        # if it does, update it
        if dog_id == query.id:
            query.name = str(args['name']),
            query.age = str(args['age']),
            query.color = str(args['color'])
            db.session.commit()
            
            return {
                'id': dog_id,
                'name': query.name,
                'age': query.age,
                'color': query.color
            }, 200
        elif query.id is None:

            newDog = Dog(id=dog_id, name=str(args['name']), color=str(args['color']))
            db.session.add(newDog)
            db.session.commit()
           
            return {
                'id': newDog.id,
                'name': newDog.name,
                'age': newDog.age,
                'color': newDog.color,
            }, 201


class allDogs(Resource):
    def get(self):
        test = Dog.query.all()
        for gay in range(len(test)):
            return {
                'id': gay.id,
                'name': gay.name,
                'age': gay.age,
                'color': gay.color
            }

class healthCheck(Resource):
    def get(self):
        return {'OK'}, 200

# endpoints
api.add_resource(healthCheck, '/health')
api.add_resource(allDogs, '/dogs', '/dogs/', '/')
api.add_resource(dogById, '/dogs/<int:dog_id>')

if __name__ == '__main__':
    app.run(
        host="0.0.0.0",
        port=5000
    )