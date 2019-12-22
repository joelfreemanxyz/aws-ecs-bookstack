#!/usr/bin/env python3

from os import environ

# function used to get environment variables. if variable is not found, it will throw an error.
def get_env_variable(name):
    try:
        return environ[name]
    except KeyError:
        message = "Expected environment variable '{}' not set.".format(name)
        raise Exception(message)

class developmentConfig(object):
    TESTING = True
    DEBUG = True
    FLASK_ENV = "development"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    POSTGRES_USER = "postgres"
    POSTGRES_PASS = "pass"
    POSTGRES_HOST = "postgres"
    POSTGRES_DB   = "postgres"
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://{user}:{password}@{host}/{db}'.format(user=POSTGRES_USER, password=POSTGRES_PASS, host=POSTGRES_HOST, db=POSTGRES_DB)

class Config(object):
    TESTING = False
    DEBUG = False
    FLASK_ENV = "production"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    POSTGRES_USER = get_env_variable("POSTGRES_USER")
    POSTGRES_PASS = get_env_variable("POSTGRES_PASS")
    POSTGRES_HOST = get_env_variable("POSTGRES_HOST")
    POSTGRES_DB   = get_env_variable("POSTGRES_DB")
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://{user}:{password}@{host}/{db}'.format(user=POSTGRES_USER, password=POSTGRES_PASS, host=POSTGRES_HOST, db=POSTGRES_DB)