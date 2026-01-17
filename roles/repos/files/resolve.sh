#!/bin/bash

TMP_NAME_FILE=/tmp/rpms.names
TMP_SNAPSHOT_FILE=/tmp/rpms.snapshot


cp -f rpms.names $TMP_NAME_FILE
cp -f rpms.snapshot $TMP_SNAPSHOT_FILE

repoquery --requires --resolve --recursive --qf "%{name}" --arch=x86_64 `cat rpms.names` >> $TMP_NAME_FILE
repoquery --requires --resolve --recursive --arch=x86_64 `cat rpms.names` >> $TMP_SNAPSHOT_FILE

sort $TMP_NAME_FILE | sed -E 's|(\..+$)||' | uniq > rpms.names