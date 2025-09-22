#!/bin/bash
# Simple Stalin compilation without volume mounts

if [ $# -eq 0 ]; then
    echo "Usage: ./compile-simple.sh <file.sc>"
    exit 1
fi

INPUT_FILE=$1
BASE_NAME=$(basename "$INPUT_FILE" .sc)

echo "🔧 Compiling $INPUT_FILE..."

# Create container and copy file
CONTAINER_ID=$(docker run --platform linux/amd64 -d stalin-x86_64 sleep 300)
docker cp "$INPUT_FILE" ${CONTAINER_ID}:/stalin/

# Generate C code
docker exec ${CONTAINER_ID} bash -c "
    cp include/stalin.architectures . 2>/dev/null
    PATH=.:\$PATH
    ./stalin -On -c -architecture AMD64 $INPUT_FILE
"

# Extract generated C code
docker cp ${CONTAINER_ID}:/stalin/${BASE_NAME}.c ./${BASE_NAME}.c 2>/dev/null

# Clean up
docker rm -f ${CONTAINER_ID} > /dev/null

# Compile if C code was generated
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