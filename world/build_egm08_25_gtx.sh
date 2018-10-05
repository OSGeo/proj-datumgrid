#!/bin/sh

set -eu

rm -rf build_egm08_25_gtx
mkdir build_egm08_25_gtx
cd build_egm08_25_gtx

wget https://freefr.dl.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz
tar xzf GeographicLib-1.49.tar.gz
cd GeographicLib-1.49
mkdir build
cd build
cmake .. -DGEOGRAPHICLIB_DATA=$PWD
wget https://sourceforge.net/projects/geographiclib/files/gravity-distrib/egm2008.zip
unzip egm2008.zip
make GeoidToGTX -j9
./examples/GeoidToGTX egm2008 24 egm08_25.gtx

echo "egm08_25.gtx available in : $PWD/egm08_25.gtx"
