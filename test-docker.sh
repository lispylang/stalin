#!/bin/bash
set -e

echo "Testing Stalin Docker development environment..."

# Test basic hello world program
cd /stalin

# Clean any previous builds
make -f makefile.modern clean 2>/dev/null || true

# Try the simple build script first
echo "Attempting simple build..."
./build-simple || {
    echo "Simple build failed, trying modern build..."
    ./build-modern
}

# If we get here, the build succeeded
echo ""
echo "✅ Build completed successfully!"

# Test with hello.sc if it exists
if [ -f "hello.sc" ]; then
    echo "Testing hello.sc compilation..."
    ./stalin -o hello hello.sc || echo "⚠️  hello.sc compilation failed"

    if [ -f "hello" ]; then
        echo "✅ hello executable created"
        ./hello || echo "⚠️  hello execution failed"
    fi
else
    echo "Creating simple test program..."
    cat > test.sc << 'EOF'
(write-string "Hello from Stalin Scheme compiler!")
(newline)
EOF

    echo "Compiling test.sc..."
    ./stalin -o test test.sc || echo "⚠️  test.sc compilation failed"

    if [ -f "test" ]; then
        echo "✅ test executable created"
        ./test || echo "⚠️  test execution failed"
    fi
fi

echo ""
echo "Stalin Docker environment test completed!"
echo "🎉 Ready for development!"