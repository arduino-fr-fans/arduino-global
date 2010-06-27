#!/bin/bash

## If stdin is empty, we read from terminal
if [ -t 0 ]
then
  while [ 1 ]
  do
    read -n 1 -s val
    echo ">${val}"
    echo -n "${val}" > /dev/ttyUSB0
  done
else
  ## we read data from stdin
  var=`cat -`
  echo -n "${var}" > /dev/ttyUSB0
fi
