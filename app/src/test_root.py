#!/usr/bin/env python

def test_root(client):
    resp = client.get("/")
    assert resp.status_code == 200
    assert b"Hello from container" in resp.data

