#!/bin/sh

set -eu

rm -rf  build_g2012
mkdir build_g2012
cd build_g2012

# See https://www.ngs.noaa.gov/GEOID/GEOID12B/ to get the below links

# Alaska
wget https://www.ngs.noaa.gov/PC_PROD/GEOID12B/Format_pc/g2012ba0.bin

# Hawaii
wget https://www.ngs.noaa.gov/PC_PROD/GEOID12B/Format_pc/g2012bh0.bin

# CONUS
wget https://www.ngs.noaa.gov/PC_PROD/GEOID12B/Format_pc/g2012bu0.bin

# Guam and Northern Mariana Islands
wget https://www.ngs.noaa.gov/PC_PROD/GEOID12B/Format_pc/g2012bg0.bin

# American Samoa
wget https://www.ngs.noaa.gov/PC_PROD/GEOID12B/Format_pc/g2012bs0.bin

# Puerto Rico and U.S. Virgin Islands
wget https://www.ngs.noaa.gov/PC_PROD/GEOID12B/Format_pc/g2012bp0.bin

for i in *.bin; do
    gdal_translate -of GTX $i `basename $i .bin`.gtx
done
