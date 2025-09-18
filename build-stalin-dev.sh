#!/bin/bash
# Stalin Development Build Script
# Works around Xcode license and other issues

set -e

echo "================================"
echo "Stalin Development Build"
echo "================================"

# Check for compiler
if command -v clang &> /dev/null; then
    CC=clang
elif command -v gcc &> /dev/null; then
    CC=gcc
else
    echo "ERROR: No C compiler found (gcc or clang required)"
    exit 1
fi

echo "Using compiler: $CC"

# 1. Ensure we have a minimal GC library
if [ ! -f "include/libgc.a" ]; then
    echo "Creating minimal GC stub..."
    cat > gc_stub.c << 'EOF'
void GC_init() {}
void GC_gcollect() {}
void* GC_malloc(unsigned long n) { return malloc(n); }
void* GC_malloc_atomic(unsigned long n) { return malloc(n); }
void GC_free(void* p) { free(p); }
EOF

    $CC -c gc_stub.c -o gc_stub.o 2>/dev/null || {
        echo "Warning: Could not compile GC stub"
    }

    if [ -f gc_stub.o ]; then
        ar rv include/libgc.a gc_stub.o
        ranlib include/libgc.a
        rm -f gc_stub.c gc_stub.o
        echo "✓ Created minimal GC library"
    fi
fi

# 2. Build Stalin runtime library
echo "Building Stalin runtime library..."
if [ -f "xlib-c.c" ]; then
    echo "  Compiling xlib-c.c (may fail if X11 not available)..."
    $CC -c -O2 -I./include xlib-c.c -o xlib-c.o 2>/dev/null || {
        echo "  X11 compilation failed, creating stub..."
        touch xlib-c.o
    }
else
    touch xlib-c.o
fi

ar rv include/libstalin.a xlib-c.o 2>/dev/null || true
echo "✓ Stalin runtime library ready"

# 3. Prepare Stalin C source
echo "Selecting Stalin C source..."
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    echo "  ARM64 detected, using IA32 fallback (for now)"
    STALIN_C="stalin-IA32.c"
elif [ "$ARCH" = "x86_64" ]; then
    STALIN_C="stalin-IA32.c"  # Use 32-bit version for now
else
    STALIN_C="stalin-IA32.c"
fi

if [ ! -f "$STALIN_C" ]; then
    if [ -f "stalin-32.c" ]; then
        cp stalin-32.c stalin.c
    else
        echo "ERROR: No Stalin C source found!"
        exit 1
    fi
else
    cp "$STALIN_C" stalin.c
fi
echo "✓ Using $STALIN_C"

# 4. Compile Stalin
echo "Compiling Stalin..."
echo "  This will produce warnings - that's normal for now"

# Compiler flags for maximum compatibility
CFLAGS="-O2 -I./include"
CFLAGS="$CFLAGS -Wno-implicit-function-declaration"
CFLAGS="$CFLAGS -Wno-int-conversion"
CFLAGS="$CFLAGS -Wno-incompatible-pointer-types"
CFLAGS="$CFLAGS -Wno-pointer-to-int-cast"
CFLAGS="$CFLAGS -Wno-int-to-pointer-cast"
CFLAGS="$CFLAGS -Wno-deprecated-declarations"
CFLAGS="$CFLAGS -fno-strict-aliasing"

# Try to compile
$CC $CFLAGS stalin.c -o stalin -L./include -lm -lgc -lstalin 2>&1 | {
    while IFS= read -r line; do
        # Filter out the most common warnings
        if [[ ! "$line" =~ "warning:" ]] && [[ ! "$line" =~ "note:" ]]; then
            echo "$line"
        fi
    done
}

# Check if compilation succeeded
if [ -f "stalin" ]; then
    echo "✅ Stalin compiled successfully!"
    echo ""
    echo "You can now test Stalin with:"
    echo "  ./stalin hello.sc"
    echo "  ./hello"

    # Make stalin executable
    chmod +x stalin

    # Show version info
    echo ""
    echo "Stalin executable info:"
    ls -lh stalin
else
    echo "❌ Stalin compilation failed"
    echo ""
    echo "Troubleshooting:"
    echo "1. Accept Xcode license: sudo xcodebuild -license"
    echo "2. Use Docker: ./docker-build.sh"
    echo "3. Check VALIDATION_RESULTS.md for known issues"
    exit 1
fi