from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'test'
db = SQLAlchemy(app)

class Dog(db.Model):
    __tablename__ = "dogs"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    age = db.Column(db.Integer)

    def __repr__(self):
        return '%s/%s/%s/%s' % (self.id, self.name, self.age)

@app.route('/health')
def healthcheck():
    return jsonify('ALIVE')


if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0')