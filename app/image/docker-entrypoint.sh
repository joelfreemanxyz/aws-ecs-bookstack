#!/bin/sh

if [ "$TESTING" = "TRUE" ]; then
    py.test
else
    python src/server.py
fi
