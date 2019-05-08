# CMake build system for proj-datumgrid releases.

cmake_minimum_required(VERSION 2.6)

# Keep msvc quiet
add_definitions( "/D_CRT_SECURE_NO_WARNINGS" )

project(PROJ_DATUMGRID)
set(PROJ_DATUMGRID_VERSION_MAJOR 1)
set(PROJ_DATUMGRID_VERSION_MINOR 9alpha1)

set(PROJ_DATUMGRID_MODULE_DIR "${PROJECT_SOURCE_DIR}/cmake")
set(CMAKE_MODULE_PATH ${PROJ_DATUMGRID_MODULE_DIR} ${CMAKE_MODULE_PATH})

add_executable(nad2bin scripts/nad2bin.c)

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "proj-datumgrid-${PROJ_DATUMGRID_VERSION_MAJOR}.${PROJ_DATUMGRID_VERSION_MINOR}")
set(CPACK_SOURCE_IGNORE_FILES "/europe/;/oceania/;/north-america/;/world/;/build.*/;/cmake/;/travis/;.travis.yml;.gitignore;CMakeLists.txt;/lla/;HOWTORELEASE;CONTRIBUTING.md;/.github/;/.git/;.swp$;.*~;.*.py;.*.sh;/scripts/;${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)

add_custom_target(convert_lla
                  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/convert_lla.cmake
                  DEPENDS nad2bin)
add_custom_target(dist  COMMAND ${CMAKE_MAKE_PROGRAM} package_source
                        DEPENDS convert_lla)
