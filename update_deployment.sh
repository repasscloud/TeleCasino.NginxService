#!/usr/bin/env bash

docker compose down
git pull
docker compose up -d --build
