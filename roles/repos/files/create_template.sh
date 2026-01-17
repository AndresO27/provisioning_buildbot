#!/bin/bash

if [ "$#" -ne 2 ]
then
  echo "Usage: create_template TEMPLATE_DIR  OUTPUT_DIR"
  exit 1
fi

TEMPLATE_DIR=$(readlink -f $1)
OUTPUT_DIR=$(readlink -f $2)

REPO_FILE=$TEMPLATE_DIR/repo_names.txt

TMP_NAME_FILE=/tmp/rpms.names
TMP_SNAPSHOT_FILE=/tmp/rpms.snapshot

if [ -e $REPO_FILE ] ; then
    
    REPO_NAMES=`cat $REPO_FILE`

    NAME_FILE=$OUTPUT_DIR/rpms.names
    SNAPSHOT_FILE=$OUTPUT_DIR/rpms.snapshot

    if [ -e $NAME_FILE ] ; then
	rm $NAME_FILE
    fi
    
    if [ -e $SNAPSHOT_FILE ] ; then
	rm $SNAPSHOT_FILE
    fi

    rm -f $TMP_NAME_FILE
    rm -f $TMP_SNAPSHOT_FILE


    for repo in $REPO_NAMES; do
	repoquery --repoid=$repo -a >> $TMP_SNAPSHOT_FILE
	repoquery --repoid=$repo -a  --qf "%{name}" >> $TMP_NAME_FILE
    done

    sort $TMP_NAME_FILE | uniq > $NAME_FILE
    sort $TMP_SNAPSHOT_FILE | uniq > $SNAPSHOT_FILE
    rm -f $TMP_NAME_FILE $TMP_SNAPSHOT_FILE

else

    NAME_FILE=$TEMPLATE_DIR/rpms.names
    SNAPSHOT_FILE=$TEMPLATE_DIR/rpms.snapshot


    if [ -e $NAME_FILE ] ; then
	cp $NAME_FILE $OUTPUT_DIR
    else
	echo "You need $TEMPLATE_DIR/rpms.names or $TEMPLATE_DIR/repo_names.txt to run this script"
	exit 1
    fi
    
    if [ -e $SNAPSHOT_FILE ] ; then
	cp $SNAPSHOT_FILE $OUTPUT_DIR
    fi

fi