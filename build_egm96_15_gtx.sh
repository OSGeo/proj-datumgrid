#!/bin/sh

set -eu

rm -rf build_egm96_15_gtx
mkdir build_egm96_15_gtx
cd build_egm96_15_gtx

wget https://freefr.dl.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz
tar xzf GeographicLib-1.49.tar.gz
cd GeographicLib-1.49
mkdir build
cd build
cmake .. -DGEOGRAPHICLIB_DATA=$PWD
wget https://netcologne.dl.sourceforge.net/project/geographiclib/gravity-distrib/egm96.zip
unzip egm96.zip
make GeoidToGTX -j9
./examples/GeoidToGTX egm96 4 egm96_15.gtx

echo "egm96_15.gtx available in : $PWD/egm96_15.gtx"
