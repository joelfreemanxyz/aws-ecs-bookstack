#!/bin/sh

if [ $CREATE_DB -eq 'true']
then
  python -c 'from app.database import db db.create_all()'
  cd app
  flask run
else
  cd app
  flask run
fi