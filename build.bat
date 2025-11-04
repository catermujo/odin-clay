@echo off

setlocal EnableDelayedExpansion

if not exist clay\NUL (
    git clone https://github.com/nicbarker/clay --depth=1
)

echo Building project...
clang clay\clay.h -o clay.lib -target x86_64-pc-windows-msvc -O3 --emit-static-lib

echo Build completed successfully!
