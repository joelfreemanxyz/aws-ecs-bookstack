#!/bin/sh

echo "$TESTING"
if [ "$TESTING" == "TRUE" ]; then
    echo "TESTING IS TRUE"
    py.test
else
    echo "$TESTING is false"
    #python src/server.py
fi