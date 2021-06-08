#!/bin/bash
set -e

SOCKEYE_COMMIT=ef908e3c5751ef072b2554f327f8081e935d9731 # 2.3.17 (sockeye:master)

# Get this version of sockeye
rootdir="$(readlink -f "$(dirname "$0")/../")"
cd $rootdir
git submodule init
git submodule update --recursive --remote sockeye
cd sockeye
git checkout $SOCKEYE_COMMIT
cd ..

$rootdir/install/install_sockeye_custom.sh -s $rootdir/sockeye -e sockeye2
