#!/bin/sh

set -eu

rm -rf  build_g2003
mkdir build_g2003
cd build_g2003

# See https://geodesy.noaa.gov/PC_PROD/GEOID03/ to get the below links

# Alaska
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003a01.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003a02.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003a03.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003a04.bin

# Hawaii
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003h01.bin

# CONUS
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u01.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u02.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u03.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u04.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u05.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u06.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u07.bin
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003u08.bin

# Puerto Rico and U.S. Virgin Islands
wget https://geodesy.noaa.gov/PC_PROD/GEOID03/g2003p01.bin

for i in g2003a*.bin g2003h*.bin g2003p*.bin; do
    gdal_translate -of GTX $i `basename $i .bin`.gtx
done

gdalbuildvrt g2003u0.vrt g2003u0*.bin
gdal_translate -of GTX g2003u0.vrt geoid03_conus.gtx

