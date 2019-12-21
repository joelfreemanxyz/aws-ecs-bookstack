#!/usr/bin/env sh

if [[ $CREATE_DB -eq 'true' ]]
then

  cd api
  python -c 'from app import db; db.create_all(); db.session.commit()'
  python app.py
else
  cd api && python app.py
fi

