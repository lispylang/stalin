#!/bin/bash

# Generate Architecture-Specific C Files Script
# This script uses Stalin self-compilation to generate C files for all architectures

set -e

STALIN_BINARY="./stalin-cosmo"
ARCHITECTURES="IA32 AMD64 ARM64 SPARC SPARCv9 SPARC64 MIPS Alpha ARM M68K PowerPC S390 PowerPC64"

if [ ! -f "$STALIN_BINARY" ]; then
    echo "Error: Stalin binary not found at $STALIN_BINARY"
    echo "Please compile Stalin first using the build script"
    exit 1
fi

if [ ! -f "$STALIN_BINARY" ] || [ ! -x "$STALIN_BINARY" ]; then
    echo "Error: Stalin binary is not executable"
    exit 1
fi

echo "Testing Stalin binary..."
if ! ./$STALIN_BINARY --help > /dev/null 2>&1; then
    echo "Error: Stalin binary failed to run"
    exit 1
fi

echo "Generating architecture-specific C files..."

OPTIONS="-d1 -d5 -d6 -On -t -c -db -clone-size-limit 4 -split-even-if-no-widening -do-not-align-strings -treat-all-symbols-as-external -do-not-index-constant-structure-types-by-expression -do-not-index-allocated-structure-types-by-expression"

for ARCH in $ARCHITECTURES; do
    echo "Generating stalin-${ARCH}.c..."

    if ! ./$STALIN_BINARY $OPTIONS -architecture $ARCH stalin; then
        echo "Warning: Failed to generate stalin-${ARCH}.c"
        continue
    fi

    if [ -f stalin.c ]; then
        mv stalin.c stalin-${ARCH}.c
        echo "✓ Generated stalin-${ARCH}.c ($(du -h stalin-${ARCH}.c | cut -f1))"
    else
        echo "✗ Failed to generate stalin-${ARCH}.c (no output file)"
    fi
done

echo "Architecture generation complete!"
echo "Generated files:"
ls -lh stalin-*.c | grep -v stalin-architecture.c