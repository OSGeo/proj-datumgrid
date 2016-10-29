# Find nad2bin executable required to convert .lla files

find_program(NAD2BIN_EXECUTABLE nad2bin
             PATHS /usr/local/bin
                   /usr/bin)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NAD2BIN DEFAULT_MSG NAD2BIN_EXECUTABLE)

