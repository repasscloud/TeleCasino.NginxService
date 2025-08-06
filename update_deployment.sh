#!/usr/bin/env bash

docker compose down
git pull
mkdir -p volumes/{baccarat,dice,keno,roulette,slots}
docker compose up -d --build
