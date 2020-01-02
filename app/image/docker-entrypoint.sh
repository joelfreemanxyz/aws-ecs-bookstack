#!/bin/sh

if [ "$TESTING" = "TRUE" ]; then
    py.test
else
    python src/server.py
    curl -f http://localhost:8080
fi
