#!/bin/bash

function run() {
  echo "$(pwd)$ $@"
  "$@" || exit 1
}

function Pushd() {
  echo "$(pwd)$ pushd $@"
  pushd "$@" || exit 1
}

function Popd() {
  echo "$(pwd)$ popd  $@"
  popd "$@" || exit 1
}

# TODO: INSTALL DEPENDENCIES

run mkdir dc

Pushd dc
  run git clone git://git.code.sf.net/p/cadcdev/kallistios kos

  run git clone git://git.code.sf.net/p/cadcdev/kos-ports
  Pushd kos-ports
    run git submodule update --init
  Popd #kos-ports

  Pushd kos/utils/dc-chain
    echo "[kallistios] begin running download.sh"
    run ./download.sh --no-deps
    echo "[kallistios] end   running download.sh"

    echo "[kallistios] begin running unpack.sh"
    run ./unpack.sh --no-deps
    echo "[kallistios] end   running unpack.sh"

    echo "[kallistios] begin running make"
    run make
    echo "[kallistios] end   running make"
  Popd #kos/utils/dc-chain

  Pushd kos
    run cp doc/environ.sh.sample ./environ.sh
    run chmod u+x environ.sh
    echo
    echo "!!! OPENING BASH SESSION. PLEASE EDIT environ.sh AND THEN RUN exit."
    run bash
    echo "!!! BASH SESSION CLOSED. THAT SHOULD REALLY BE AUTOMATED."
    echo "$(pwd)$ source environ.sh"
    source environ.sh
    run make
  Popd #kos

  Pushd kos-ports/utils
    run ./build-all
  Popd #kos-ports
Popd #dc

