#!/usr/bin/env bash

[ -d clay ] || git clone --revision b16c7a48e1274e06b4a8826fc0f21b093f0a9396 https://github.com/catermujo/clay --depth 1
# git -C clay pull --rebase

./build-clay-lib.sh

cp clay/bindings/odin/clay-odin/clay.odin .
cp clay/bindings/odin/clay-odin/macos-arm64/clay.a clay.darwin.a
cp clay/bindings/odin/clay-odin/linux/clay.a clay.linux.a
cp clay/bindings/odin/clay-odin/windows/clay.lib clay.lib
cp clay/bindings/odin/clay-odin/wasm/clay.o clay.wasm.o
