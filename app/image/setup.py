#!/usr/bin/env python3

from setuptools import setup, find_packages

setup(
    name="hello-world-ecs",
    version="1.0",
    packages=find_packages(),

    install_requires=['flask','pytest', 'pytest-flask'],

    project_urls={
        "Source Code": "https://github.com/joelfreemanxyz/aws-ecs-ha-app/"
    }
)