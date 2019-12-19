#!/usr/bin/env python3

from flask_sqlalchemy import SQLAlchemy
from os import environ

def get_env_variable(name):
    try:
        return environ[name]
    except KeyError:
        message = "Expected environment variable '{}' not set.".format(name)
        raise Exception(message)

# env variables
POSTGRES_USER = get_env_variable("POSTGRES_USER")
POSTGRES_PASS = get_env_variable("POSTGRES_PASS")
POSTGRES_HOST = get_env_variable("POSTGRES_HOST")
POSTGRES_DB   = get_env_variable("POSTGRES_DB")
CREATE_DB     = get_env_variable("CREATE_DB")
DB_URI        = 'postgresql+psycopg2://{user}:{password}@{host}/{db}'.format(user=POSTGRES_USER, password=POSTGRES_PASS, host=POSTGRES_HOST, db=POSTGRES_DB)

db = SQLAlchemy()