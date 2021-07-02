#!/bin/bash

mkdir -p /build/logs;

cd /build/Harness;
alr build > /build/logs/harness_build.log;
alr run > /build/logs/test.log;
