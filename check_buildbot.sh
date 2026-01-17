#!/bin/bash


cd "$BUILDBOTPATH"
if [ -f twistd.pid ]; then
    PID=$(cat twistd.pid)
    if kill -0 $PID 2>/dev/null; then
    echo "running"
    else
    echo "stopped"
    fi
else
    echo "stopped"
fi