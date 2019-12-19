#!/usr/bin/env python3

from flask_restful import Resource

class healthCheck(Resource):
    def get(self):
        return {'OK'}, 200
