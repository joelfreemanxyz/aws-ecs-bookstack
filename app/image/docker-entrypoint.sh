#!/bin/sh

echo "$TESTING"
if [ "$TESTING" == "TRUE" ]; then
    echo "TESTING IS TRUE"
    py.test
else
    echo "$TESTING"
    python src/server.py
fi