#!/bin/bash

echo \>compiling dependency.cpp...
cd cpp/
g++ -c dependency.cpp
cd ..
echo \>done.

echo \>start dub...
dub test
echo \>done.
