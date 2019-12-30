#!/bin/sh

if [ "$TESTING" == "TRUE" ]; then
    py.test
else
    python server.py
fi
