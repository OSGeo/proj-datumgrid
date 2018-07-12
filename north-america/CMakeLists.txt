# CMake build system for proj-datumgrid-north-america releases.

cmake_minimum_required(VERSION 2.6)

project(PROJ_DATUMGRID_NORTHAMERICA)
set(PROJ_DATUMGRID_NORTHAMERICA_VERSION_MAJOR 1)
set(PROJ_DATUMGRID_NORTHAMERICA_VERSION_MINOR 1alpha1)

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "proj-datumgrid-north-america-${PROJ_DATUMGRID_NORTHAMERICA_VERSION_MAJOR}.${PROJ_DATUMGRID_NORTHAMERICA_VERSION_MINOR}")
set(CPACK_SOURCE_IGNORE_FILES "/build/;/cmake/;/.github/;CMakeLists.txt;.swp$;.*~;.*.py;${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)

add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)
