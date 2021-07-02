#!/bin/bash

rm -r /build/logs;
rm -r /build/firmware.uf2;

cd /build/Trains_With_Ada;
alr clean;
rm -r obj;
rm -r alire.lock;
rm -r alire;

cd /build/Harness;
alr clean;
rm -r obj;
rm -r bin;
rm -r alire.lock;
rm -r alire;

