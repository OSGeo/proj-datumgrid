# CMake build system for proj-datumgrid-world releases.

cmake_minimum_required(VERSION 2.6)

project(PROJ_DATUMGRID_WORLD)
set(PROJ_DATUMGRID_WORLD_VERSION_MAJOR 1)
set(PROJ_DATUMGRID_WORLD_VERSION_MINOR 0)

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "proj-datumgrid-world-${PROJ_DATUMGRID_WORLD_VERSION_MAJOR}.${PROJ_DATUMGRID_WORLD_VERSION_MINOR}")
set(CPACK_SOURCE_IGNORE_FILES "/build.*/;/cmake/;/.github/;CMakeLists.txt;.gitattributes;.swp$;.*~;.*.py;.*.sh;${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)

function(get_file_size var filename)
    file(READ "${filename}" content HEX)
    string(LENGTH "${content}" content_length)
    math(EXPR content_length "${content_length} / 2")
    set(${var} ${content_length} PARENT_SCOPE)
endfunction()

get_file_size(SIZE "egm08_25.gtx")
set(EXPECTED_SIZE "149333800")
if (NOT ${SIZE} STREQUAL ${EXPECTED_SIZE})
    MESSAGE(FATAL_ERROR "Size of egm08_25.gtx is ${SIZE} instead of expected ${EXPECTED_SIZE}. git-lfs is likely not installed !")
endif()

add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)
