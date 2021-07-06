#!/bin/bash

mkdir -p /build/logs;
{
    cd /build/Trains_With_Ada;
    alr build;
    elf2uf2 /build/Trains_With_Ada/obj/main /build/firmware.uf2;
} > /build/logs/build.log 2> /build/logs/build-error.log;
