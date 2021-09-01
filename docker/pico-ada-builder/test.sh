#!/bin/bash

mkdir -p /build/logs;
{
    cd /build/Harness;
    alr build;
    elf2uf2 /build/Harness/obj/test_trains_with_ada /build/test_firmware.uf2;
} > /build/logs/test.log 2> /build/logs/test-error.log;

