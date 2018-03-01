# CMake build system for proj-datumgrid releases.

cmake_minimum_required(VERSION 2.6)

project(PROJ_DATUMGRID)
set(PROJ_DATUMGRID_VERSION_MAJOR 1)
set(PROJ_DATUMGRID_VERSION_MINOR 8alpha1)

set(PROJ_DATUMGRID_MODULE_DIR "${PROJECT_SOURCE_DIR}/cmake")
set(CMAKE_MODULE_PATH ${PROJ_DATUMGRID_MODULE_DIR} ${CMAKE_MODULE_PATH})

find_package(NAD2BIN REQUIRED)

set(DATUMGRIDS alaska
               conus
               FL
               hawaii
               MD
               null
               prvi
               stgeorge
               stlrnc
               stpaul
               TN
               WI
               WO)

foreach(GRIDFILE ${DATUMGRIDS})
    message(STATUS "Creating grid file: ${GRIDFILE}")

    execute_process(COMMAND ${NAD2BIN_EXECUTABLE} -f ctable2
                            ${PROJECT_SOURCE_DIR}/${GRIDFILE}
                    INPUT_FILE ${PROJECT_SOURCE_DIR}/lla/${GRIDFILE}.lla
                    OUTPUT_QUIET)
endforeach(GRIDFILE)

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "proj-datumgrid-${PROJ_DATUMGRID_VERSION_MAJOR}.${PROJ_DATUMGRID_VERSION_MINOR}")
set(CPACK_SOURCE_IGNORE_FILES "/europe/;/oceania/;/north-america/;/build/;/cmake/;CMakeLists.txt;/lla/;HOWTORELEASE;/.github/;/.git/;.swp$;.*~;${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)

add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)
