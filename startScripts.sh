#!/bin/bash

echo "start with $2"

K6_OUT=influxdb=http://192.168.23.55:8086/k6 k6 run "scripts/$2.js"