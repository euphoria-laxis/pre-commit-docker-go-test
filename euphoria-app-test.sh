#!/usr/bin/env bash

set -eu -o pipefail

if ! command -v docker-compose &> /dev/null ; then
    echo "docker-compose not installed or available in the PATH" >&2
    echo "please check https://docs.docker.com/compose/install/" >&2
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    echo "Please add `args: [-container=app]` in your pre-commit config"
    exit 1
fi

# start containers required for tests (database, redis, etc)
for d in "$3"
do
    echo "start container $d in background"
    docker-compose up $d -d
    sleep 5 # wait for containers to start
done

docker-compose up $1 # run test container

# stop additional containers
for d in "$3"
do
    echo "stop container $d"
    docker-compose stop $d
done

docker-compose stop $1 # stop test container