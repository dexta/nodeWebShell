#!/bin/bash

echo "start with $2"

K6_OUT=influxdb=http://lxmoncol02:8086/loadtests k6 run "scripts/$2.js"