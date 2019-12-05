#!/bin/bash

#echo "build_cci sh."
if [ -f cci-src/cci/.libs/libcascci.a ];then
#  echo "libcascci.a exist."
  exit 0
fi

cd cci-src
sed -i "s/^AM_PROG_CC_C_O/AM_PROG_CC_C_O\nCC=g++/" configure.ac
chmod +x configure
chmod +x external/libregex38a/configure
if [ "$1" = 'x86' ];then
  ./configure 
else
  ./configure --enable-64bit
fi

make
sed -i "^/CC=g++/d" configure.ac
