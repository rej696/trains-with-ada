#!/bin/bash

mkdir -p /build/logs;

cd /build/Trains_With_Ada;
alr build > /build/logs/build.log;

elf2uf2 /build/Trains_With_Ada/obj/main /build/firmware.uf2;
