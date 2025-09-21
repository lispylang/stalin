#!/bin/bash
# Stalin ARM64 Bootstrap Script
# =============================
# This script bootstraps Stalin for ARM64/Apple Silicon by:
# 1. Building an x86_64 Docker environment
# 2. Compiling Stalin in x86_64 mode
# 3. Generating AMD64 C code for Stalin
# 4. Compiling the AMD64 code natively on ARM64

set -e  # Exit on any error

echo "🚀 Stalin ARM64 Bootstrap Process Starting..."
echo "============================================="

# Check prerequisites
echo "📋 Checking prerequisites..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is required but not installed"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running. Please start Docker Desktop."
    exit 1
fi

echo "✅ Docker is available"

# Step 1: Build x86_64 Docker environment
echo ""
echo "🏗️  Step 1: Building x86_64 Docker environment..."
docker build --platform linux/amd64 -t stalin-x86_64 -f Dockerfile.x86_64 . --quiet
echo "✅ Docker environment built"

# Step 2: Test the environment
echo ""
echo "🧪 Step 2: Testing x86_64 emulation..."
ARCH=$(docker run --platform linux/amd64 --rm stalin-x86_64 uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    echo "✅ x86_64 emulation working"
else
    echo "❌ x86_64 emulation failed: got $ARCH"
    exit 1
fi

# Step 3: Test Stalin binary in container
echo ""
echo "🔬 Step 3: Testing Stalin binary..."
STALIN_SIZE=$(docker run --platform linux/amd64 --rm stalin-x86_64 ls -la stalin | awk '{print $5}')
if [[ $STALIN_SIZE -gt 1000000 ]]; then
    echo "✅ Stalin binary exists (${STALIN_SIZE} bytes)"
else
    echo "❌ Stalin binary too small or missing"
    exit 1
fi

# Step 4: Generate AMD64 hello world test
echo ""
echo "🎯 Step 4: Testing AMD64 code generation..."
docker run --platform linux/amd64 --rm stalin-x86_64 bash -c "
    cp include/stalin.architectures . &&
    PATH=.:\$PATH &&
    ./stalin -On -c -architecture AMD64 hello.sc &&
    ls -la hello.c
" > /dev/null

if [[ $? -eq 0 ]]; then
    echo "✅ AMD64 code generation working"
else
    echo "❌ AMD64 code generation failed"
    exit 1
fi

# Step 5: Extract and test hello world
echo ""
echo "📤 Step 5: Extracting and testing AMD64 code..."
docker run --platform linux/amd64 --name stalin-extract -d stalin-x86_64 bash -c "
    cp include/stalin.architectures . &&
    PATH=.:\$PATH &&
    ./stalin -On -c -architecture AMD64 hello.sc &&
    sleep 30
" > /dev/null

sleep 3
docker cp stalin-extract:/stalin/hello.c hello-amd64-test.c > /dev/null 2>&1
docker rm -f stalin-extract > /dev/null 2>&1

if gcc -o hello-amd64-test -I./include hello-amd64-test.c -L./include -lm -lgc 2>/dev/null; then
    OUTPUT=$(./hello-amd64-test 2>/dev/null)
    if [[ "$OUTPUT" == "Hello, World!" ]]; then
        echo "✅ AMD64 code compiles and runs correctly"
        rm -f hello-amd64-test hello-amd64-test.c
    else
        echo "❌ AMD64 code output incorrect: '$OUTPUT'"
        exit 1
    fi
else
    echo "❌ AMD64 code compilation failed"
    exit 1
fi

# Step 6: Generate Stalin itself (this takes a long time)
echo ""
echo "⏳ Step 6: Generating Stalin AMD64 code (this may take 30+ minutes)..."
echo "   Starting background process..."

# Clean up any existing containers
docker rm -f stalin-main-bootstrap 2>/dev/null || true

docker run --platform linux/amd64 --name stalin-main-bootstrap -d stalin-x86_64 bash -c "
    cp include/stalin.architectures . &&
    cp include/*.sc . &&
    PATH=.:\$PATH &&
    timeout 7200 ./stalin -On -c -architecture AMD64 stalin.sc &&
    echo 'STALIN_GENERATION_COMPLETE' &&
    ls -la stalin.c &&
    sleep 300
" > /dev/null

echo "   Container started. You can monitor progress with:"
echo "   docker logs stalin-main-bootstrap"
echo ""
echo "   When complete, extract the generated code with:"
echo "   docker cp stalin-main-bootstrap:/stalin/stalin.c stalin-amd64.c"
echo ""
echo "   Then compile natively with:"
echo "   gcc -o stalin-arm64 -I./include -O2 stalin-amd64.c -L./include -lm -lgc"
echo ""

echo "🎉 Bootstrap process initiated successfully!"
echo "   The AMD64 Stalin generation is running in the background."
echo "   Total expected time: 30-60 minutes depending on your system."

# Function to check completion
cat << 'EOF' > check_bootstrap.sh
#!/bin/bash
echo "Checking Stalin bootstrap progress..."
if docker logs stalin-main-bootstrap 2>&1 | grep -q "STALIN_GENERATION_COMPLETE"; then
    echo "✅ Stalin generation complete!"
    echo "Extracting stalin-amd64.c..."
    docker cp stalin-main-bootstrap:/stalin/stalin.c stalin-amd64.c
    echo "✅ stalin-amd64.c extracted"
    echo "Cleaning up container..."
    docker rm -f stalin-main-bootstrap
    echo "🎉 Bootstrap complete! You can now compile with:"
    echo "   gcc -o stalin-arm64 -I./include -O2 stalin-amd64.c -L./include -lm -lgc"
    rm check_bootstrap.sh
else
    echo "⏳ Stalin generation still in progress..."
    echo "Run this script again in a few minutes to check."
fi
EOF

chmod +x check_bootstrap.sh
echo "   Run ./check_bootstrap.sh to check completion status."