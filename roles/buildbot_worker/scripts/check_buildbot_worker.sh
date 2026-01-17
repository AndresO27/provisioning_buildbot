#!/bin/bash
BUILDBOT_WORKER_PATH=$1

cd "$BUILDBOT_WORKER_PATH"
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