#!/usr/bin/env bash
cd clay/bindings/odin || exit
if [ $(uname -s) = 'Darwin' ]; then
    PATH="/opt/homebrew/opt/llvm/bin:$PATH" ./build-clay-lib.sh
else
    ./build-clay-lib.sh
fi

# FLAGS="-static -O3 -nostdlib -ffreestanding -fPIC"
#
# cp clay/clay.h clay.c
# # Intel Mac
# # clang -c -DCLAY_IMPLEMENTATION -o clay.o -ffreestanding -static -target x86_64-apple-darwin clay.c -fPIC -O3 && ar r clay-odin/macos/clay.a clay.o;
# # ARM Mac
# clang -c -DCLAY_IMPLEMENTATION -o clay.o clay.c $FLAGS && ar r clay.a clay.o && mv clay.a clay.darwin.a
# # x64 Windows
# clang -c -DCLAY_IMPLEMENTATION -o clay.lib -target x86_64-pc-windows-msvc -fuse-ld=llvm-lib clay.c $FLAGS
# # Linux
# clang -c -DCLAY_IMPLEMENTATION -o clay.o -target x86_64-unknown-linux-gnu clay.c $FLAGS && ar r clay.a clay.o && mv clay.a clay.linux.a
# # WASM
# clang -c -DCLAY_IMPLEMENTATION -o clay.o -target wasm32 clay.c $FLAGS && mv clay.o clay.wasm.o
# rm clay.o
# rm clay.c
