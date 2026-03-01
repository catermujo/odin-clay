@echo off

setlocal EnableDelayedExpansion

if not exist clay (
    git clone --revision b16c7a48e1274e06b4a8826fc0f21b093f0a9396 https://github.com/catermujo/clay --depth=1
)

echo Building project...
clang clay\clay.h -o clay.lib -target x86_64-pc-windows-msvc -O3 --emit-static-lib

echo Build completed successfully!
