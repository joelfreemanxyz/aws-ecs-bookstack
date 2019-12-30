#!/usr/bin/env python3
import pytest
from src.app import create_app

@pytest.fixture
def app():
    app = create_app()
    return app