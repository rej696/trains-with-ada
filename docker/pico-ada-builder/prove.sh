#!/bin/bash

# docker run --rm -t -i -v $(pwd):/build rej696/pico-ada-builder:latest gnatprove -P /build/Trains_With_Ada/Trains_With_Ada.gpr -u $1
# docker run --rm -t -i -v $(pwd):/build rej696/pico-ada-builder:latest ls /build/Trains_With_Ada
cd /build;
mkdir -p logs;

alr build > logs/build.log;

# alr printenv | grep 'GPR_PROJECT_PATH=*' | awk -F "\"" '{print $2}'
export GPR_PROJECT_PATH=$(alr printenv | grep 'GPR_PROJECT_PATH=*' | awk -F "\"" '{print $2}');
gnatprove -P /build/Trains_With_Ada/Trains_With_Ada.gpr -u $1 > logs/prove.log;
