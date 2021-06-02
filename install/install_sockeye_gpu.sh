#!/bin/bash
set -e

SOCKEYE_COMMIT=ba8f849804e99c9fac3ff31ce4dac3758fcda95b # 2.3.16 (sockeye:master)

# Get this version of sockeye
rootdir="$(readlink -f "$(dirname "$0")/../")"
cd $rootdir
git submodule init
git submodule update --recursive --remote sockeye
cd sockeye
git checkout $SOCKEYE_COMMIT
cd ..

$rootdir/install/install_sockeye_custom.sh -s $rootdir/sockeye -e sockeye2
