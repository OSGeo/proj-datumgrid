#!/bin/sh

set -eu
rm -rf build_harn
mkdir build_harn
cd build_harn
wget https://www.ngs.noaa.gov/PC_PROD/NADCON/NADCON.zip
unzip NADCON.zip nadcon.jar
unzip nadcon.jar
../../scripts/loslas2ntv2.py -auto grids/*hpgn.los
mv grids/*.gsb ..
cd ..
rm -rf build_harn
