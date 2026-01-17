#!/bin/bash

if [ "$#" -ne 2 ]
then
  echo "Usage: create_rpm_snapshot RPM_DIR OUTPUT_DIR"
  exit 1
fi

RPM_DIR=$(readlink -f $1)
OUTPUT_DIR=$(readlink -f $2)

echo "RPM_DIR: $RPM_DIR"
echo "OUTPUT_DIR: $OUTPUT_DIR"

NAME_FILE=$OUTPUT_DIR/rpms.names
SNAPSHOT_FILE=$OUTPUT_DIR/rpms.snapshot

TMP_NAME_FILE=/tmp/rpms.names
TMP_SNAPSHOT_FILE=/tmp/rpms.snapshot


if [ -e $NAME_FILE ] ; then
    rm $NAME_FILE
fi

if [ -e $SNAPSHOT_FILE ] ; then
    rm $SNAPSHOT_FILE
fi

rm -f $TMP_NAME_FILE
rm -f $TMP_SNAPSHOT_FILE

echo "Creating rpm.names and rpm.snapshot based on RPMs in $RPM_DIR..."

NUM_FILES=$(ls -1 $RPM_DIR/*.rpm | wc -l)
i=0

for file in $RPM_DIR/*.rpm
do
   full_package_name=`basename $file .rpm`
   package_name=$(rpm -qp --qf "%{name}" $file)
   echo $package_name >> $TMP_NAME_FILE
   echo $full_package_name >> $TMP_SNAPSHOT_FILE
   let i=i+1 
   echo -ne "$i/$NUM_FILES\r"
done

echo

sort $TMP_NAME_FILE | uniq > $NAME_FILE
sort $TMP_SNAPSHOT_FILE | uniq > $SNAPSHOT_FILE
rm -f $TMP_NAME_FILE $TMP_SNAPSHOT_FILE