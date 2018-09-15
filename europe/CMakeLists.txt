# CMake build system for proj-datumgrid-europe releases.

cmake_minimum_required(VERSION 2.6)

project(PROJ_DATUMGRID_EUROPE)
set(PROJ_DATUMGRID_EUROPE_VERSION_MAJOR 1)
set(PROJ_DATUMGRID_EUROPE_VERSION_MINOR 2alpha1)

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "proj-datumgrid-europe-${PROJ_DATUMGRID_EUROPE_VERSION_MAJOR}.${PROJ_DATUMGRID_EUROPE_VERSION_MINOR}")
set(CPACK_SOURCE_IGNORE_FILES "/build/;/cmake/;/.github/;CMakeLists.txt;.swp$;.*~;.*.py;${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)

add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)
