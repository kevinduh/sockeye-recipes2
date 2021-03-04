#!/bin/bash
set -e

SOCKEYE_COMMIT=c3870e38f0a446ae5bf3920d5872908d282444d4 # 2.3.10 (sockeye:master)

# Get this version of sockeye
rootdir="$(readlink -f "$(dirname "$0")/../")"
cd $rootdir
git submodule init
git submodule update --recursive --remote sockeye
cd sockeye
git checkout $SOCKEYE_COMMIT
cd ..

$rootdir/install/install_sockeye_custom.sh -s $rootdir/sockeye -e sockeye2
