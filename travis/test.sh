#!/bin/sh

set -eu

rm -rf build_travis
mkdir build_travis
cd build_travis
cmake ..
make dist
cd ..

SUBDIRS="europe north-america oceania world"

for subdir in $SUBDIRS; do
    cd $subdir
    rm -rf build_travis
    mkdir build_travis
    cd build_travis
    cmake ..
    make dist
    cd ..
    cd ..
done

unzip -l  build_travis/proj-datumgrid*.zip | tail -n +4 | head -n -2 | awk '{print $4}' | sort > /tmp/got_main.lst
if ! diff -u travis/expected_main.lst /tmp/got_main.lst; then
    echo "Got difference in proj-datumgrid"
    exit 1;
fi

for subdir in $SUBDIRS; do
    unzip -l  ./${subdir}/build_travis/proj-datumgrid-${subdir}*.zip | tail -n +4 | head -n -2 | awk '{print $4}' | sort > /tmp/got_${subdir}.lst
    if ! diff -u travis/expected_${subdir}.lst /tmp/got_${subdir}.lst; then
        echo "Got difference in proj-datumgrid-${subdir}"
        exit 1;
    fi
done
