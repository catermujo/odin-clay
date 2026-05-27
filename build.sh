#!/usr/bin/env bash

clone_at_revision() {
    local dir="$1"
    local revision="$2"
    local remote="$3"
    shift 3
    [ -d "$dir" ] && return
    git clone "$@" "$remote" "$dir"
    if ! git -C "$dir" checkout --detach "$revision"; then
        git -C "$dir" fetch origin "$revision"
        git -C "$dir" checkout --detach FETCH_HEAD
    fi
    if [ -f "$dir/.gitmodules" ]; then
        git -C "$dir" submodule update --init --recursive
    fi
}

clone_at_revision clay b16c7a48e1274e06b4a8826fc0f21b093f0a9396 https://github.com/catermujo/clay --depth=1
# git -C clay pull --rebase

./build-clay-lib.sh

cp clay/bindings/odin/clay-odin/clay.odin .
cp clay/bindings/odin/clay-odin/macos-arm64/clay.a clay.darwin.a
cp clay/bindings/odin/clay-odin/linux/clay.a clay.linux.a
cp clay/bindings/odin/clay-odin/windows/clay.lib clay.lib
cp clay/bindings/odin/clay-odin/wasm/clay.o clay.wasm.o
