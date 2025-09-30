# Stalin Scheme Compiler - Installation Guide

## Overview

Stalin is a Scheme compiler that generates optimized C code for multiple architectures. This guide covers installation and setup using the modern Cosmopolitan toolchain approach (Docker-free).

## Prerequisites

### Required Tools
- `curl` or `wget` (for downloading)
- `unzip` (for extracting archives)
- A C compiler (GCC recommended)

### Supported Platforms
- Linux (x86_64, ARM64)
- macOS (Intel, Apple Silicon)
- Windows (WSL recommended)
- FreeBSD, OpenBSD, NetBSD

## Quick Installation

### 1. Clone or Download Stalin

```bash
git clone <stalin-repository>
cd stalin
```

### 2. Install Cosmopolitan Toolchain

Run the automated installation script:

```bash
./install-cosmo-toolchain.sh
```

This script will:
- Download the latest Cosmopolitan toolchain
- Set up the development environment
- Configure Stalin integration
- Test the installation

### 3. Set Up Environment

```bash
source ./setup-cosmo-env.sh
```

Or add to your shell profile:
```bash
export PATH="$PWD/cosmocc/bin:$PATH"
```

### 4. Test Installation

```bash
# Test basic compilation
./compile hello.sc

# Run architecture tests
./test-architectures-cosmo.sh

# Run full test suite
make test
```

## Manual Installation

If the automated script doesn't work for your system:

### 1. Download Cosmopolitan Toolchain

```bash
# Download latest release
wget https://github.com/jart/cosmopolitan/releases/download/3.9.4/cosmocc-3.9.4.zip

# Extract
mkdir cosmocc
cd cosmocc
unzip ../cosmocc-3.9.4.zip
cd ..
```

### 2. Build Stalin (if needed)

```bash
# Try native build first
make native

# If that fails, use the build-modern script
./build-modern
```

### 3. Set Up Integration

```bash
# Create integration directory
mkdir -p cosmocc/include

# Copy Stalin binary
cp stalin cosmocc/include/stalin  # or stalin-native if that's what you have

# Copy include files
cp -r include/* cosmocc/include/

# Make executable
chmod +x cosmocc/include/stalin
chmod +x cosmocc/bin/*
```

## Usage

### Basic Compilation

```bash
# Compile to universal binary (default)
./compile hello.sc

# Compile for specific architecture
./compile hello.sc AMD64
./compile hello.sc ARM64
./compile hello.sc Cosmopolitan
```

### Architecture Support

Stalin supports cross-compilation for:
- **IA32** - Intel 32-bit
- **AMD64** - Intel/AMD 64-bit
- **ARM** - ARM 32-bit
- **ARM64** - ARM 64-bit
- **RISCV64** - RISC-V 64-bit
- **PowerPC** - PowerPC architecture
- **SPARC** - SPARC architecture
- **Cosmopolitan** - Universal binary (recommended)

### Build System

```bash
# Set up environment
make setup-cosmo

# Build Stalin
make build

# Run tests
make test

# Install system-wide
sudo make install

# Clean build artifacts
make clean
```

## Troubleshooting

### Installation Issues

**Cosmopolitan toolchain not found:**
```bash
# Verify installation
ls -la cosmocc/bin/cosmocc
file cosmocc/bin/cosmocc

# Check PATH
echo $PATH | grep cosmocc
```

**Stalin binary issues:**
```bash
# Test Stalin directly
./cosmocc/include/stalin --help

# Check if binary is executable
chmod +x cosmocc/include/stalin
```

### Compilation Issues

**C compilation fails:**
```bash
# Check cosmocc is working
cosmocc --version

# Test simple C program
echo 'int main(){return 0;}' | cosmocc -x c - -o test
```

**Architecture-specific issues:**
```bash
# Run architecture tests
./test-architectures-cosmo.sh

# Check generated C code
./compile yourfile.sc
cat yourfile.c  # Examine generated code
```

### Platform-Specific Notes

**macOS Apple Silicon:**
- Cosmopolitan toolchain provides x86_64 emulation
- Generated binaries work on both Intel and Apple Silicon Macs

**Linux ARM64:**
- Native ARM64 compilation supported
- Universal binaries run on both ARM64 and x86_64

**Windows:**
- Use WSL (Windows Subsystem for Linux) for best compatibility
- Native Windows support via Cosmopolitan universal binaries

## Migration from Docker

If upgrading from a Docker-based installation:

### 1. Remove Docker Dependencies

```bash
# Stop and remove containers
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# Remove images
docker image rm stalin-x86_64 stalin-cosmo 2>/dev/null || true
```

### 2. Install Cosmopolitan Toolchain

```bash
./install-cosmo-toolchain.sh
```

### 3. Update Scripts

The following scripts have been updated for Cosmopolitan:
- `./compile` - Main compilation script
- `./test-architectures-cosmo.sh` - Architecture testing
- `./makefile` - Build system

## Advanced Configuration

### Custom Cosmopolitan Build

To use a custom Cosmopolitan build:

```bash
# Build from source
git clone https://github.com/jart/cosmopolitan.git
cd cosmopolitan
make -j8
cd ..

# Link to Stalin
ln -sf $PWD/cosmopolitan/bin cosmocc/bin
```

### Performance Tuning

For optimal performance:

```bash
# Use optimization flags
export COSMO_CFLAGS="-O3 -DNDEBUG -fomit-frame-pointer"

# Enable architecture-specific optimizations
./compile yourfile.sc Cosmopolitan
```

## Support

### Documentation
- `README.md` - Project overview
- `ARCHITECTURE_SUPPORT.md` - Architecture compatibility
- `PERFORMANCE_NOTES.md` - Performance guidelines

### Testing
- `./test-architectures-cosmo.sh` - Architecture compatibility tests
- `make test` - Full test suite
- `./compile minimal.sc && ./minimal` - Quick smoke test

### Issues
For installation issues, please check:
1. Prerequisites are installed
2. Cosmopolitan toolchain is properly extracted
3. PATH includes the cosmocc directory
4. Stalin binary is executable and accessible

### Community
- GitHub Issues for bug reports
- Discussions for usage questions
- Wiki for advanced configuration examples