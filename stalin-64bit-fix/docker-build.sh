#!/bin/bash
# Docker-based Stalin 64-bit builder
# Runs Stalin in 32-bit environment, generates 64-bit C code

set -e

echo "================================================"
echo "Stalin 64-bit Fix - Docker Approach"
echo "================================================"
echo

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker daemon is not running"
    echo "Please start Docker Desktop:"
    echo "  open -a Docker"
    echo
    echo "Then wait a minute and run this script again."
    exit 1
fi

echo "✅ Docker is running"
echo

# Get absolute path to Stalin directory
STALIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "Stalin directory: $STALIN_DIR"
echo

# Create a script to run inside the container
cat > /tmp/stalin-build-inside.sh << 'INNER_SCRIPT'
#!/bin/bash
set -e

echo "📦 Inside 32-bit container"
echo "Architecture: $(uname -m)"
echo "Pointer size: $(getconf LONG_BIT) bits"
echo

echo "📚 Installing dependencies..."
apt-get update -qq
apt-get install -y -qq gcc g++ make libgc-dev >/dev/null 2>&1
echo "✅ Dependencies installed"
echo

echo "🔨 Building Stalin in 32-bit mode..."
cd /stalin
if [ ! -f ./stalin ]; then
    ./build 2>&1 | head -50
fi

if [ -f ./stalin ]; then
    echo "✅ Stalin binary built"
else
    echo "❌ Stalin build failed"
    exit 1
fi

echo
echo "🎯 Generating stalin.c with AMD64 (64-bit) architecture..."
echo "Command: ./stalin -architecture AMD64 -Ob -Om -On -Or -Ot stalin.sc"
echo

# Generate stalin.c with 64-bit settings
./stalin -architecture AMD64 \
    -Ob -Om -On -Or -Ot \
    stalin.sc 2>&1 | grep -v "^;;;" | head -100

if [ -f stalin.c ]; then
    echo
    echo "✅ stalin.c generated!"
    echo
    echo "📊 Checking for 64-bit indicators..."

    # Check pointer size in generated code
    if grep -q "pointer.*8" stalin.c; then
        echo "✅ Found 8-byte pointer references"
    fi

    # Check for 32-bit assertions (should NOT be there)
    if grep -q "sizeof.*4" stalin.c; then
        echo "⚠️  Warning: Found sizeof==4 assertions"
    else
        echo "✅ No 32-bit assertions found"
    fi

    echo
    echo "📋 Copying stalin.c to stalin-64bit-fix/"
    cp stalin.c /stalin/stalin-64bit-fix/stalin-64bit.c

    echo
    echo "✅ SUCCESS! stalin-64bit.c is ready"
    echo
    echo "Next steps:"
    echo "  1. Exit this container (type 'exit')"
    echo "  2. Compile with Cosmopolitan:"
    echo "     cosmocc -o stalin-64bit.com stalin-64bit.c"
    echo "  3. Test the binary:"
    echo "     ./stalin-64bit.com --version"
else
    echo "❌ stalin.c generation failed"
    exit 1
fi
INNER_SCRIPT

chmod +x /tmp/stalin-build-inside.sh

echo "🐳 Starting 32-bit Debian container..."
echo

# Run the container
docker run --rm -it --platform linux/386 \
    -v "$STALIN_DIR":/stalin \
    -v /tmp/stalin-build-inside.sh:/build.sh \
    -w /stalin \
    debian:bullseye \
    /bin/bash /build.sh

echo
echo "🎉 Docker build complete!"
