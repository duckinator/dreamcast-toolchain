#!/bin/bash

if [ "$1" == "--rebuild" ]; then
  docker build -t dreamcast-build . || exit $?
fi

docker run --rm -it -v "$(pwd):/workspace/dc-exp" -w /workspace/dc-exp dreamcast-build || exit $?
