# Stalin Scheme Compiler - Installation Guide

## Quick Installation (Recommended)

### macOS with Homebrew

```bash
# Install directly from this repository
brew install --build-from-source /path/to/stalin.rb

# Or if you have a tap set up:
brew install your-tap/stalin
```

### Universal Installation

```bash
# Clone the repository
git clone https://github.com/celicoo/stalin.git
cd stalin

# Build and install (requires Docker)
make docker-build
sudo make install

# Test installation
stalin minimal.sc
```

## Installation Methods

### Method 1: Docker-Based Build (Recommended for ARM64/Apple Silicon)

This method works on all platforms and provides the most reliable experience:

```bash
# Prerequisites
# - Docker Desktop installed and running
# - Git
# - make

# 1. Clone and build
git clone https://github.com/celicoo/stalin.git
cd stalin
make docker-build

# 2. Test the build
make test

# 3. Install system-wide (optional)
sudo make install

# 4. Use Stalin
stalin yourfile.sc
```

### Method 2: Native Build (Linux/x86_64 only)

For traditional x86_64 Linux systems, you can attempt a native build:

```bash
# Prerequisites
# - GCC compiler
# - Development tools (make, tar, gzip)

# 1. Clone the repository
git clone https://github.com/celicoo/stalin.git
cd stalin

# 2. Attempt native build
make native

# 3. If successful, install
sudo make install
```

**Note**: Native builds may fail on ARM64 systems. Use the Docker method instead.

## Installation Verification

After installation, verify Stalin is working:

```bash
# Check version and system info
make version

# Compile a simple program
echo '(display "Hello Stalin!")(newline)' > hello.sc
stalin hello.sc
./hello
```

Expected output: `Hello Stalin!`

## Usage

### Basic Compilation

```bash
# Compile a Scheme file
stalin yourfile.sc

# This creates an executable with the same name (without .sc extension)
./yourfile
```

### Advanced Usage

```bash
# Use the enhanced compilation pipeline directly
./compile-fast.sh yourfile.sc

# Compile multiple files
./compile-fast.sh *.sc

# Clean build artifacts
make clean

# Deep clean (including Docker containers)
make distclean
```

## Directory Structure After Installation

```
/usr/local/
├── bin/
│   ├── stalin                    # Main Stalin wrapper
│   └── stalin-compile            # Enhanced compilation script
├── lib/stalin/
│   ├── docker-build.sh           # Docker environment builder
│   ├── stalin-architecture-name  # Architecture detection
│   └── examples/                 # Example Scheme programs
└── include/stalin/               # Include files and libraries
    ├── *.h                       # C header files
    └── lib*.a                    # Static libraries
```

## Customizing Installation

### Custom Installation Directory

```bash
# Install to a custom prefix
make install PREFIX=/opt/stalin

# Update PATH to include the custom location
export PATH="/opt/stalin/bin:$PATH"
```

### Development Installation

For development work, you may want to keep Stalin in your development directory:

```bash
# Build but don't install system-wide
make docker-build

# Use Stalin from the development directory
./compile-fast.sh yourfile.sc

# Or add the development directory to PATH
export PATH="/path/to/stalin:$PATH"
```

## Uninstallation

To remove Stalin from your system:

```bash
# Using the Makefile
sudo make uninstall

# Manual removal (if needed)
sudo rm -f /usr/local/bin/stalin /usr/local/bin/stalin-compile
sudo rm -rf /usr/local/lib/stalin /usr/local/include/stalin
```

## Troubleshooting

### Docker Issues

```bash
# Check Docker is running
docker info

# Rebuild Docker image if needed
make distclean
make docker-build
```

### macOS Docker File Sharing Error

If you get `Mounts denied: The path ... is not shared from the host`:

**Solution 1 (Recommended):**
1. Open **Docker Desktop** → **Settings** (gear icon)
2. Go to **Resources** → **File sharing**
3. Click **+** and add your project directory path
4. Click **Apply & restart**

**Solution 2 (Alternative):**
```bash
# Create symlink in shared directory
ln -s /path/to/stalin ~/Desktop/stalin
cd ~/Desktop/stalin
# Now Docker commands will work
```

**Solution 3 (Move project):**
```bash
# Move to standard shared directory
mv /Applications/lispylang/stalin ~/Documents/stalin
cd ~/Documents/stalin
```

### Permission Issues

```bash
# Fix file permissions
chmod +x compile-fast.sh docker-build.sh stalin-architecture-name

# Use sudo for system-wide installation
sudo make install
```

### Architecture Issues

Stalin automatically detects your architecture. If you encounter issues:

```bash
# Check detected architecture
./stalin-architecture-name

# View system information
make version
```

### Build Failures

If the Docker build fails:

```bash
# Clean everything and retry
make distclean
docker system prune -f
make docker-build
```

If native build fails on ARM64:

```bash
# Use Docker method instead
make docker-build
```

## Performance Notes

- **First compilation**: May take 2-3 minutes (Docker image download + container setup)
- **Subsequent compilations**: 4-6 seconds with container reuse
- **Binary size**: Generated executables are typically 100KB-2MB
- **Compilation speed**: Stalin is optimized for runtime performance, not compile time

## Platform Support

| Platform | Method | Status |
|----------|---------|---------|
| ARM64 macOS (Apple Silicon) | Docker | ✅ Fully Supported |
| x86_64 macOS (Intel) | Docker | ✅ Fully Supported |
| x86_64 Linux | Docker/Native | ✅ Fully Supported |
| ARM64 Linux | Docker | ✅ Fully Supported |
| Windows | Docker (WSL2) | 🧪 Experimental |

## Getting Help

- **Build Issues**: Check the Docker logs and ensure prerequisites are met
- **Runtime Issues**: Verify the generated C code compiles with your system GCC
- **Performance Issues**: Stalin is designed for production use; development builds may be slower

For additional help, see the development documentation in `DEVELOPMENT.md`.