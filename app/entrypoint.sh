#!/usr/bin/env sh

if [[ $CREATE_DB -eq 'true' ]]
then
  python -c 'from api.core import db; db.create_all()'
  cd api && python app.py
else
  cd api && python app.py
fi

