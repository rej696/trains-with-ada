#!/bin/bash

docker run --rm -t -i -v $(pwd):/build rej696/pico-ada-builder:latest bash /build/docker/pico-ada-builder/prove.sh $1
