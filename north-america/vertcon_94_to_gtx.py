#!/usr/bin/env python
# -*- coding: utf-8 -*-
###############################################################################
# $Id$
#
#  Project:  PROJ
#  Purpose:  Convert original VERTCON .94 grids from
#            https://www.ngs.noaa.gov/PC_PROD/VERTCON/VERTCON.zip to
#            .gtx grids
#  Author:   Even Rouault <even.rouault at spatialys.com>
#
###############################################################################
#  Copyright (c) 2018, Even Rouault <even.rouault at spatialys.com>
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included
#  in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
#  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#  DEALINGS IN THE SOFTWARE.
###############################################################################


from osgeo import gdal
import sys
import struct

if len(sys.argv) != 3:
    print('Usage: vertcon_94_to_gtx.py source.94 target.gtx')
    sys.exit(1)

# Read file header
src_file = open(sys.argv[1], 'rb')
src_file.seek(64, 0)
width = struct.unpack('<I', src_file.read(4))[0]
height = struct.unpack('<I', src_file.read(4))[0]
one = struct.unpack('<I', src_file.read(4))[0]
assert one == 1, one
ll_long = struct.unpack('<f', src_file.read(4))[0]
res_long = round(struct.unpack('<f', src_file.read(4))[0], 2)
ll_lat = struct.unpack('<f', src_file.read(4))[0]
res_lat = round(struct.unpack('<f', src_file.read(4))[0], 2)

print(width, height, ll_long, res_long, ll_lat, res_lat)

src_file.seek(0, 2)
file_size = src_file.tell()
data_offset = 1852
extra_val_at_end_of_line = 1  # for some reason, one extra float at end of each line. Perhaps the value of the 'one' variable
size_of_float = 4
expected_size = data_offset + \
    (width + extra_val_at_end_of_line) * (height - 1) * size_of_float + \
    width * size_of_float
assert file_size == expected_size, (file_size, expected_size)

ds = gdal.GetDriverByName('GTX').Create(
    sys.argv[2], width, height, 1, gdal.GDT_Float32)
# Convert from lower-left center-of-pixel to upper-left corner-of-pixel
ds.SetGeoTransform([ll_long - res_long / 2, res_long, 0,
                    ll_lat + (height - 1) * res_lat + res_lat / 2, 0, -res_lat])

# Convert data lines
for j in range(height):
    src_file.seek(data_offset + (width + extra_val_at_end_of_line)
                  * j * size_of_float)
    line_val = [v for v in struct.unpack(
        '<' + ('f' * width), src_file.read(size_of_float * width))]
    for i in range(width):
        # Remap for original nodata value to GTX one
        if line_val[i] == 9999:
            line_val[i] = ds.GetRasterBand(1).GetNoDataValue()
    line_val = ''.join([struct.pack('f', line_val[i]) for i in range(width)])
    # Order of lines in source file is from south to north
    ds.GetRasterBand(1).WriteRaster(0, height - 1 - j, width,
                                    1, line_val, buf_type=gdal.GDT_Float32)
ds = None
