#!/bin/bash

count=1

while [ $count -lt 100 ] 
do
  echo $count
  count=$[$count+1]
  sleep 1s
done

echo "end of the earth"