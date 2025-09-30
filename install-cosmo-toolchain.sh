#!/bin/bash
# Cosmopolitan Toolchain Installation Script
# ==========================================
#
# This script downloads and sets up the Cosmopolitan toolchain for Stalin
# Replaces Docker dependency with native universal binary compilation
#
# Author: Claude Code Development Team
# Date: 2024

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COSMO_VERSION="3.9.4"  # Latest stable version as of 2024
COSMO_URL="https://github.com/jart/cosmopolitan/releases/download/${COSMO_VERSION}/cosmocc-${COSMO_VERSION}.zip"
COSMO_DIR="./cosmocc"
STALIN_SOURCE_DIR="./cosmocc/include"

echo -e "${BLUE}Cosmopolitan Toolchain Installation for Stalin${NC}"
echo -e "${BLUE}=============================================${NC}"
echo "This script will download and install the Cosmopolitan toolchain"
echo "Version: $COSMO_VERSION"
echo ""

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

# Check if we're in the right directory
if [ ! -f "stalin.sc" ] || [ ! -f "compile" ]; then
    echo -e "${RED}Error: This script must be run from the Stalin project root directory${NC}"
    echo "Please ensure you're in the directory containing stalin.sc and compile scripts"
    exit 1
fi

# Check for required tools
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo -e "${RED}Error: Either curl or wget is required to download the toolchain${NC}"
    exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
    echo -e "${RED}Error: unzip is required to extract the toolchain${NC}"
    exit 1
fi

echo -e "${GREEN}Prerequisites OK${NC}"
echo ""

# Check if already installed
if [ -d "$COSMO_DIR" ] && [ -f "$COSMO_DIR/bin/cosmocc" ]; then
    echo -e "${YELLOW}Cosmopolitan toolchain already exists at $COSMO_DIR${NC}"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
    echo "Removing existing installation..."
    rm -rf "$COSMO_DIR"
fi

# Download Cosmopolitan toolchain
echo -e "${BLUE}Downloading Cosmopolitan toolchain...${NC}"
TEMP_FILE="/tmp/cosmocc-${COSMO_VERSION}.zip"

if command -v curl >/dev/null 2>&1; then
    curl -L -o "$TEMP_FILE" "$COSMO_URL"
else
    wget -O "$TEMP_FILE" "$COSMO_URL"
fi

if [ ! -f "$TEMP_FILE" ]; then
    echo -e "${RED}Error: Failed to download Cosmopolitan toolchain${NC}"
    exit 1
fi

echo -e "${GREEN}Download completed${NC}"

# Extract toolchain
echo -e "${BLUE}Extracting toolchain...${NC}"
mkdir -p "$COSMO_DIR"
cd "$COSMO_DIR"
unzip -q "$TEMP_FILE"
cd ..

# Clean up download
rm -f "$TEMP_FILE"

# Verify installation
echo -e "${BLUE}Verifying installation...${NC}"
if [ ! -f "$COSMO_DIR/bin/cosmocc" ]; then
    echo -e "${RED}Error: cosmocc not found after extraction${NC}"
    exit 1
fi

# Make tools executable
chmod +x "$COSMO_DIR"/bin/*

echo -e "${GREEN}Cosmopolitan toolchain installed successfully${NC}"

# Copy Stalin binary to Cosmopolitan include directory
echo -e "${BLUE}Setting up Stalin integration...${NC}"

# Create include directory if it doesn't exist
mkdir -p "$STALIN_SOURCE_DIR"

# Check if we have a pre-built Stalin binary
if [ -f "stalin-native" ]; then
    echo "Copying native Stalin binary..."
    cp "stalin-native" "$STALIN_SOURCE_DIR/stalin"
elif [ -f "stalin" ]; then
    echo "Copying Stalin binary..."
    cp "stalin" "$STALIN_SOURCE_DIR/stalin"
else
    echo -e "${YELLOW}Warning: No Stalin binary found${NC}"
    echo "You'll need to build Stalin first or provide a pre-built binary"
    echo "Expected locations: ./stalin or ./stalin-native"
fi

# Copy Stalin include files
if [ -d "include" ]; then
    echo "Copying Stalin include files..."
    cp -r include/* "$STALIN_SOURCE_DIR/" 2>/dev/null || true
fi

# Make Stalin binary executable
if [ -f "$STALIN_SOURCE_DIR/stalin" ]; then
    chmod +x "$STALIN_SOURCE_DIR/stalin"
    echo -e "${GREEN}Stalin integration complete${NC}"
fi

# Test the installation
echo -e "${BLUE}Testing installation...${NC}"

export PATH="$PWD/$COSMO_DIR/bin:$PATH"

if "$COSMO_DIR/bin/cosmocc" --version >/dev/null 2>&1; then
    echo -e "${GREEN}cosmocc is working${NC}"
else
    echo -e "${RED}Error: cosmocc test failed${NC}"
    exit 1
fi

if [ -f "$STALIN_SOURCE_DIR/stalin" ]; then
    if "$STALIN_SOURCE_DIR/stalin" --help >/dev/null 2>&1 || "$STALIN_SOURCE_DIR/stalin" -help >/dev/null 2>&1; then
        echo -e "${GREEN}Stalin binary is working${NC}"
    else
        echo -e "${YELLOW}Warning: Stalin binary test failed${NC}"
        echo "This may be normal if Stalin requires specific arguments"
    fi
fi

echo ""
echo -e "${GREEN}Installation completed successfully!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Add Cosmopolitan toolchain to your PATH:"
echo "   export PATH=\"\$PWD/$COSMO_DIR/bin:\$PATH\""
echo ""
echo "2. Test compilation:"
echo "   ./compile hello.sc"
echo ""
echo "3. Run architecture tests:"
echo "   ./test-architectures-cosmo.sh"
echo ""
echo -e "${BLUE}Notes:${NC}"
echo "- The Cosmopolitan toolchain creates universal binaries"
echo "- Generated binaries run on Linux, Mac, Windows, FreeBSD, OpenBSD, NetBSD"
echo "- No Docker dependency required"
echo "- All compilation is now done natively"

# Create environment setup script
cat > setup-cosmo-env.sh << 'EOF'
#!/bin/bash
# Cosmopolitan Environment Setup
# Add this to your shell profile or source it before using Stalin

# Add Cosmopolitan toolchain to PATH
export PATH="$PWD/cosmocc/bin:$PATH"

# Verify setup
if command -v cosmocc >/dev/null 2>&1; then
    echo "✅ Cosmopolitan toolchain ready"
    echo "💡 Use './compile yourfile.sc' to compile Scheme programs"
else
    echo "❌ Cosmopolitan toolchain not found"
    echo "   Run ./install-cosmo-toolchain.sh to install"
fi
EOF

chmod +x setup-cosmo-env.sh

echo ""
echo "Created setup-cosmo-env.sh for easy environment configuration"
echo "Run: source ./setup-cosmo-env.sh"