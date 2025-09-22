#!/bin/bash
# Compile Scheme files using Docker-based Stalin

if [ $# -eq 0 ]; then
    echo "Usage: ./compile-scheme.sh <file.sc>"
    exit 1
fi

INPUT_FILE=$1
BASE_NAME=$(basename "$INPUT_FILE" .sc)

echo "🔧 Compiling $INPUT_FILE..."

# Generate AMD64 C code using Docker
docker run --platform linux/amd64 --rm -v $(pwd):/work -w /work stalin-x86_64 bash -c "
    cp include/stalin.architectures . 2>/dev/null
    PATH=.:\$PATH
    ./stalin -On -c -architecture AMD64 $INPUT_FILE
"

# Compile the generated C code natively
if [ -f "${BASE_NAME}.c" ]; then
    echo "📦 Building native ARM64 binary..."
    gcc -o "$BASE_NAME" -I./include -O2 "${BASE_NAME}.c" -L./include -lm -lgc 2>/dev/null

    if [ -f "$BASE_NAME" ]; then
        echo "✅ Success! Run with: ./$BASE_NAME"
    else
        echo "❌ Compilation failed"
    fi
else
    echo "❌ Failed to generate C code"
fi