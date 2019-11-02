#!/bin/sh

set -eu

rm -rf  build_g1999
mkdir build_g1999
cd build_g1999

# See https://geodesy.noaa.gov/PC_PROD/GEOID99/ to get the below links

# Alaska
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999a01.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999a02.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999a03.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999a04.bin

# Hawaii
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999h01.bin

# CONUS
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u01.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u02.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u03.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u04.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u05.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u06.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u07.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999u08.bin

# Puerto Rico and U.S. Virgin Islands
wget https://geodesy.noaa.gov/PC_PROD/GEOID99/g1999p01.bin

for i in *.bin; do
    gdal_translate -of GTX $i `basename $i .bin`.gtx
done
