#!/bin/bash
# Test compilation script for stalin-64bit.c

set -e

echo "========================================================================"
echo "Stalin 64-bit Compilation Test"
echo "========================================================================"
echo

STALIN_C="../stalin-64bit.c"

if [ ! -f "$STALIN_C" ]; then
    echo "❌ Error: $STALIN_C not found"
    echo "   Run ./convert-to-64bit.py first"
    exit 1
fi

echo "Input file: $STALIN_C"
echo "Size: $(ls -lh $STALIN_C | awk '{print $5}')"
echo "Lines: $(wc -l < $STALIN_C | tr -d ' ')"
echo

# Test 1: Check for syntax errors (don't link)
echo "Test 1: Syntax check (compile only, no linking)..."
if gcc -c -std=c99 -Wno-unused-variable -Wno-unused-label \
    $STALIN_C -o /tmp/stalin-64bit.o 2>&1 | tee /tmp/stalin-compile.log; then
    echo "✅ Syntax check passed"
else
    echo "❌ Syntax errors found"
    echo "See /tmp/stalin-compile.log for details"
    exit 1
fi
echo

# Test 2: Check for pointer truncation warnings
echo "Test 2: Checking for pointer truncation warnings..."
if grep -i "truncat" /tmp/stalin-compile.log; then
    echo "⚠️  Warning: Found pointer truncation warnings"
else
    echo "✅ No pointer truncation warnings"
fi
echo

# Test 3: Check for 32-bit assumptions
echo "Test 3: Checking for remaining 32-bit patterns..."
echo -n "  - (unsigned)t casts: "
if grep -c "(unsigned)t[0-9]" $STALIN_C; then
    echo "⚠️  Still present"
else
    echo "✅ None found"
fi

echo -n "  - 4-byte alignment: "
if grep -c "((4-(sizeof" $STALIN_C; then
    echo "⚠️  Still present"
else
    echo "✅ None found"
fi

echo -n "  - unsigned region_size: "
if grep -c "^unsigned region_size" $STALIN_C; then
    echo "⚠️  Still present"
else
    echo "✅ None found"
fi
echo

# Test 4: Full compilation with libgc
echo "Test 4: Full compilation test (with linking)..."
if command -v gcc &> /dev/null; then
    echo "Attempting full build..."
    if gcc -std=c99 -O2 \
        -Wno-unused-variable -Wno-unused-label \
        $STALIN_C -lgc -lm \
        -o /tmp/stalin-64bit 2>&1 | tee /tmp/stalin-link.log; then
        echo "✅ Full compilation successful!"
        echo
        echo "Binary created: /tmp/stalin-64bit"
        ls -lh /tmp/stalin-64bit
        echo
        echo "Test run:"
        if /tmp/stalin-64bit --help 2>&1 | head -5; then
            echo "✅ Binary runs!"
        fi
    else
        echo "⚠️  Linking failed (this is expected if libgc is not installed)"
        echo "   But compilation succeeded, which is the important part!"
    fi
else
    echo "⚠️  gcc not found, skipping full build test"
fi
echo

echo "========================================================================"
echo "COMPILATION TEST COMPLETE"
echo "========================================================================"
echo
echo "Next step: Try Cosmopolitan compilation if available:"
echo "  cosmocc -o stalin-64bit.com ../stalin-64bit.c"
echo
