#!/bin/sh

set -eu

rm -rf  build_g2018
mkdir build_g2018
cd build_g2018

# See https://www.ngs.noaa.gov/GEOID/GEOID18/ to get the below links

# CONUS
wget https://geodesy.noaa.gov/PC_PROD/GEOID18/Format_pc/g2018u0.bin

# Puerto Rico and U.S. Virgin Islands
wget https://www.ngs.noaa.gov/PC_PROD/GEOID18/Format_pc/g2018p0.bin

for i in *.bin; do
    gdal_translate -of GTX $i `basename $i .bin`.gtx
done
