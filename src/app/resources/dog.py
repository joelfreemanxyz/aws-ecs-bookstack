#!/usr/bin/env python3

from flask_restful import Resource
from app.database import db
from app.models import Dog

class dogById(Resource):
    def get(self, dog_id):
        query = db.Dog.query.filter_by(id=dog_id).first()
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
    def put(self, dog_id, dog_name, dog_age, dog_color):
        dog_name = request.body['name']
        dog_age = request.body['age']
        dog_color = request.body['color']

        newDog = Dog(id=dog_id, name=dog_name, age=dog_age, color=dog_color)
        db.session.add(newDog)
        db.session.commit()

        return {
            'id': dog_id,
            'name': newDog.name,
            'age': newDog.age,
            'color': newDog.color
        }
 