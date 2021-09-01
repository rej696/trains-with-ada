#!/bin/bash

mkdir -p /build/logs/;
{
    cd /build/Trains_With_Ada;
    alr update -n;

    cd /build/Harness;
    alr update -n;
} &> /build/logs/update.log
