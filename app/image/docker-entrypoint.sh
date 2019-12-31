#!/bin/sh

if [ $TESTING -eq "TRUE" ]; then
    echo "TESTING IS TRUE"
    py.test
else
    echo "$TESTING is false"
    python src/server.py
fi