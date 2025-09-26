#!/bin/bash
set -e

echo "Testing Stalin Docker development environment..."
echo "=============================================="

# Test basic hello world program
cd /stalin

echo "🔧 Environment Information:"
echo "   Platform: $(uname -m) $(uname -s)"
echo "   GCC: $(gcc --version | head -1)"
echo "   Docker: Running in container"
echo ""

# Clean any previous builds
echo "🧹 Cleaning previous builds..."
make -f makefile.modern clean 2>/dev/null || true

# Try different build strategies with better error reporting
echo "🚀 Attempting Stalin build strategies..."
echo ""

echo "Strategy 1: Simple build..."
if ./build-simple 2>&1; then
    echo "✅ Simple build succeeded!"
    BUILD_SUCCESS=1
else
    echo "❌ Simple build failed"
    echo ""

    echo "Strategy 2: Modern build with ARM64 fixes..."
    if ./build-modern 2>&1; then
        echo "✅ Modern build succeeded!"
        BUILD_SUCCESS=1
    else
        echo "❌ Modern build also failed"
        echo ""

        echo "🔍 Diagnostic Information:"
        echo "   Available Stalin C files:"
        ls -la stalin-*.c 2>/dev/null || echo "   No stalin-*.c files found"
        echo "   GC library status:"
        ls -la include/libgc.a 2>/dev/null || echo "   No GC library found"
        echo "   Include directory:"
        ls -la include/ | head -10
        echo ""

        BUILD_SUCCESS=0
    fi
fi

# Test compilation if build succeeded
if [ "$BUILD_SUCCESS" = "1" ]; then
    echo ""
    echo "✅ Build completed successfully!"
    echo ""

    echo "🧪 Testing Stalin compilation..."

    # Test with existing test files
    if [ -f "minimal.sc" ]; then
        echo "Testing minimal.sc compilation..."
        if ./stalin -o minimal minimal.sc 2>/dev/null; then
            echo "✅ minimal.sc compiled successfully"
            if ./minimal 2>/dev/null; then
                echo "✅ minimal executable runs correctly"
            else
                echo "⚠️  minimal execution failed"
            fi
            rm -f minimal minimal.c
        else
            echo "❌ minimal.sc compilation failed"
        fi
    elif [ -f "hello.sc" ]; then
        echo "Testing hello.sc compilation..."
        if ./stalin -o hello hello.sc 2>/dev/null; then
            echo "✅ hello.sc compiled successfully"
            if ./hello 2>/dev/null; then
                echo "✅ hello executable runs correctly"
            else
                echo "⚠️  hello execution failed"
            fi
            rm -f hello hello.c
        else
            echo "❌ hello.sc compilation failed"
        fi
    else
        echo "Creating simple test program..."
        cat > test.sc << 'EOF'
(display "Hello from Stalin Scheme compiler!")
(newline)
EOF

        echo "Testing test.sc compilation..."
        if ./stalin -o test test.sc 2>/dev/null; then
            echo "✅ test.sc compiled successfully"
            if ./test 2>/dev/null; then
                echo "✅ test executable runs correctly"
            else
                echo "⚠️  test execution failed"
            fi
            rm -f test test.c test.sc
        else
            echo "❌ test.sc compilation failed"
        fi
    fi
else
    echo ""
    echo "❌ All build strategies failed!"
    echo ""
    echo "🔍 This indicates a fundamental issue with the build system."
    echo "   Check the error messages above for specific problems."
    echo ""
    exit 1
fi

echo ""
echo "🎉 Stalin Docker environment test completed!"
if [ "$BUILD_SUCCESS" = "1" ]; then
    echo "✅ Ready for development!"
else
    echo "❌ Build system needs attention"
    exit 1
fi