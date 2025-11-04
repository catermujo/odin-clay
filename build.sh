#!/usr/bin/env bash

[ -d clay ] || git clone https://github.com/nicbarker/clay --depth 1

cp clay/bindings/odin/clay-odin/macos-arm64/clay.a clay.darwin.a
cp clay/bindings/odin/clay-odin/linux/clay.a clay.linux.a
cp clay/bindings/odin/clay-odin/windows/clay.lib clay.lib

# if [ $(uname -s) = 'Darwin' ]; then
#     LIB_EXT="darwin"
# else
#     LIB_EXT="linux"
# fi
# this build doesn't actually work on macos...
# clang -c -DCLAY_IMPLEMENTATION -o clay.o -static clay/clay.h -fPIC -O3 && ar r clay.a clay.o
# mv clay.a clay.$LIB_EXT.a
# rm clay.o
