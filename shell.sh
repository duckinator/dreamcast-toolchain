#!/bin/bash

if [ "$1" == "--rebuild" ]; then
  docker build -t dreamcast-toolchain . || exit $?
  exit
fi

docker run --rm -it -v "$(pwd):/workspace" -w /workspace -u "$(id -u):$(id -g)" dreamcast-toolchain "$@" || exit $?
