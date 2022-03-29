#!/bin/bash
# Install dependencies
apt update
apt install libzstd-dev libhdf5-dev libcurl4-openssl-dev gcc make wget m4
cd /tmp
# Download netcdf C source code
wget https://downloads.unidata.ucar.edu/netcdf-c/4.8.1/netcdf-c-4.8.1.tar.gz
# Decompress
tar xvf netcdf-c-4.8.1.tar.gz
cd netcdf-c-4.8.1
# Include HDF5 library locations
# Make sure this configure output says Byte-Range Support:     yes
CFLAGS="-I/usr/include/hdf5/serial" LDFLAGS="-L/usr/lib/x86_64-linux-gnu/hdf5/serial/" ./configure --enable-byterange
# Compile with 4 threads
make -j 4
# Install to /usr/local/bin
make install
# Configure dynamic linker run-time bindings
ldconfig
cd /tmp
# Clean up
rm -rf netcdf-c-4.8.1.tar.gz netcdf-c-4.8.1
