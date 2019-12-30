#!/usr/bin/env python

def test_healcheck(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    assert b"all good!" in resp.data