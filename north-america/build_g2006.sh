#!/bin/sh

set -eu

rm -rf  build_g2006
mkdir build_g2006
cd build_g2006

# See https://geodesy.noaa.gov/PC_PROD/GEOID06/ to get the below links

# Alaska
wget https://geodesy.noaa.gov/PC_PROD/GEOID06/g2006a01.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID06/g2006a02.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID06/g2006a03.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID06/g2006a04.bin

gdalbuildvrt geoid06_ak.vrt g2006a0*.bin
gdal_translate -of GTX geoid06_ak.vrt geoid06_ak.gtx
