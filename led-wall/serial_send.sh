#!/bin/bash

while [ 1 ]
do
  read -n 1 -s val
  echo ">${val}"
  echo -n "${val}" > /dev/ttyUSB0
done
