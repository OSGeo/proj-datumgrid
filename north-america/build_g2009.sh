#!/bin/sh

set -eu

rm -rf  build_g2009
mkdir build_g2009
cd build_g2009

# See https://geodesy.noaa.gov/PC_PROD/GEOID09/ to get the below links

# Alaska
wget https://geodesy.noaa.gov/PC_PROD/GEOID09/Format_pc/GEOID09_ak.bin

# Hawaii
wget https://geodesy.noaa.gov/PC_PROD/GEOID09/Format_pc/g2009h01.bin

# CONUS
wget https://geodesy.noaa.gov/PC_PROD/GEOID09/Format_pc/GEOID09_conus.bin

# Guam and Northern Mariana Islands
wget https://geodesy.noaa.gov/PC_PROD/GEOID09/Format_pc/g2009g01.bin

# American Samoa
wget https://geodesy.noaa.gov/PC_PROD/GEOID09/Format_pc/g2009s01.bin

# Puerto Rico and U.S. Virgin Islands
wget https://geodesy.noaa.gov/PC_PROD/GEOID09/Format_pc/g2009p01.bin

for i in g2009*.bin; do
    gdal_translate -of GTX $i `basename $i .bin`.gtx
done

gdal_translate -of GTX GEOID09_conus.bin geoid09_conus.gtx

gdal_translate -of GTX GEOID09_ak.bin geoid09_ak.gtx
