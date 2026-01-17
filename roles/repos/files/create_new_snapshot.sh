#!/bin/bash
# summary:
# - creates a new folder with the current date
# - take a RPMS snapshot of the 'latest' repo
# - copy over Makefile


SNAPSHOT_DIR=$PWD/$(date +%Y_%m_%d)

if [ -e $SNAPSHOT_DIR ] ; then
    echo "Snapshot directory already exists!"
    exit -1
fi

mkdir $SNAPSHOT_DIR
    
if [ -e latest ] ; then
    
    ./scripts/create_rpms_snapshot.sh latest $SNAPSHOT_DIR
    
    cp latest/Makefile $SNAPSHOT_DIR/
    
else
   
    ./scripts/create_template.sh  template $SNAPSHOT_DIR
    cp template/Makefile $SNAPSHOT_DIR/
    
fi