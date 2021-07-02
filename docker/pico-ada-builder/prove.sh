#!/bin/bash

mkdir -p /build/logs;

cd /build/Trains_With_Ada/
alr build > /build/logs/build.log;

# alr printenv | grep 'GPR_PROJECT_PATH=*' | awk -F "\"" '{print $2}'
export GPR_PROJECT_PATH=$(alr printenv | grep 'GPR_PROJECT_PATH=*' | awk -F "\"" '{print $2}');
gnatprove -P /build/Trains_With_Ada/Trains_With_Ada.gpr -u $1 > /build/logs/prove.log;
