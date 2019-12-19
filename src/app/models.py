#!/usr/bin/env python3
from app.database import db
from flask_sqlalchemy import SQLAlchemy

class Dog(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    age = db.Column(db.Integer)
    color = db.Column(db.String(255))

    def __repr__(self):
        return '<Dog (id=%d, name=%s, age=%d, color=%s)>' % (
            self.id, self.name, self.age, self.color 
    )