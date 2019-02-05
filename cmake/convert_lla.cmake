set(CMAKE_SOURCE_DIR ..)
set(LLA_DIR ${CMAKE_SOURCE_DIR}/lla)
set(NAD2BIN_CMD ${CMAKE_BUILD_DIR}/nad2bin)

file(GLOB_RECURSE LLA_FILES ${LLA_DIR}/*.lla)

foreach(lla ${LLA_FILES})
    get_filename_component(GRIDNAME ${lla} NAME_WE)
    execute_process(COMMAND nad2bin -f ctable2 ${CMAKE_SOURCE_DIR}/${GRIDNAME}
                    INPUT_FILE ${lla}
                    OUTPUT_QUIET)
endforeach()