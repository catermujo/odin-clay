#!/usr/bin/env bash

[ -d clay ] || git clone https://github.com/catermujo/clay --depth 1
# git -C clay pull --rebase

./build-clay-lib.sh

cp clay/bindings/odin/clay-odin/clay.odin .
cp clay/bindings/odin/clay-odin/macos-arm64/clay.a clay.darwin.a
cp clay/bindings/odin/clay-odin/linux/clay.a clay.linux.a
cp clay/bindings/odin/clay-odin/windows/clay.lib clay.lib
cp clay/bindings/odin/clay-odin/wasm/clay.o clay.wasm.o
