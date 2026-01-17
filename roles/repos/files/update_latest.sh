#!/bin/bash

if [ "$#" -eq 0 ]
then
    SNAPSHOT_DIR=$(date +%Y_%m_%d)
elif [ "$#" -eq 1 ]
then
    SNAPSHOT_DIR=$1
else
  echo "Usage: update_latest [DIR_NAME]"
fi

echo "Setting 'latest' -> $SNAPSHOT_DIR/"

rm -f latest
ln -s $SNAPSHOT_DIR latest