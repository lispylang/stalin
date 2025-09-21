#!/bin/bash
# Simplified Stalin ARM64 Bootstrap Script
# =========================================

set -e

echo "🚀 Stalin ARM64 Bootstrap (Simplified)"
echo "======================================"
echo ""

# 1. Build Docker image
echo "📦 Building Docker environment..."
docker build --platform linux/amd64 -t stalin-x86_64 -f Dockerfile.x86_64 . --quiet
echo "✅ Done"
echo ""

# 2. Generate AMD64 code
echo "⚙️  Generating AMD64 code for hello.sc..."
docker run --platform linux/amd64 --rm -v $(pwd)/output:/output stalin-x86_64 bash -c "
    cp include/stalin.architectures . &&
    PATH=.:\$PATH &&
    ./stalin -On -c -architecture AMD64 hello.sc &&
    cp hello.c /output/hello-amd64.c 2>/dev/null || true
" 2>/dev/null || echo "Note: Volume mount may not work on all Docker setups"

# Alternative method if volume mount doesn't work
if [ ! -f output/hello-amd64.c ]; then
    echo "   Using container copy method..."
    CONTAINER_ID=$(docker run --platform linux/amd64 -d stalin-x86_64 bash -c "
        cp include/stalin.architectures . &&
        PATH=.:\$PATH &&
        ./stalin -On -c -architecture AMD64 hello.sc &&
        sleep 30
    ")
    sleep 10
    docker cp ${CONTAINER_ID}:/stalin/hello.c hello-amd64.c 2>/dev/null || true
    docker rm -f ${CONTAINER_ID} > /dev/null 2>&1
fi

if [ -f hello-amd64.c ] || [ -f output/hello-amd64.c ]; then
    [ -f output/hello-amd64.c ] && mv output/hello-amd64.c hello-amd64.c
    echo "✅ Generated hello-amd64.c ($(wc -l < hello-amd64.c) lines)"
else
    echo "❌ Failed to generate AMD64 code"
    exit 1
fi
echo ""

# 3. Compile natively
echo "🔨 Compiling AMD64 code natively..."
gcc -o hello-amd64 -I./include hello-amd64.c -L./include -lm -lgc 2>/dev/null || {
    echo "⚠️  Compilation had warnings (expected)"
}

if [ -f hello-amd64 ]; then
    echo "✅ Binary created"
else
    echo "❌ Compilation failed"
    exit 1
fi
echo ""

# 4. Test
echo "🧪 Testing binary..."
OUTPUT=$(./hello-amd64 2>/dev/null || echo "Failed")
if [[ "$OUTPUT" == "Hello, World!" ]]; then
    echo "✅ SUCCESS: '$OUTPUT'"
    echo ""
    echo "🎉 Bootstrap validation complete!"
    echo ""
    echo "Next steps:"
    echo "1. To generate Stalin itself (takes 30+ minutes):"
    echo "   docker run --platform linux/amd64 --rm stalin-x86_64 bash -c \\"
    echo "     'cp include/*.sc . && cp include/stalin.architectures . && \\"
    echo "      PATH=.:\$PATH && ./stalin -On -c -architecture AMD64 stalin.sc'"
    echo ""
    echo "2. Extract and compile:"
    echo "   docker cp container:/stalin/stalin.c stalin-amd64.c"
    echo "   gcc -o stalin-arm64 -I./include -O2 stalin-amd64.c -L./include -lm -lgc"
else
    echo "❌ Output was: '$OUTPUT'"
    echo "   The binary may have issues with the GC library"
fi