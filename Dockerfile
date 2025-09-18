#
# Stalin Scheme Compiler - Development Environment
# ================================================
#
# This Docker image provides a consistent development environment for building
# the Stalin Scheme compiler across different host platforms (x86_64, ARM64).
#
# The image is based on Ubuntu 20.04 LTS which provides:
# - Stable, well-tested package ecosystem
# - GCC 7.x with good C99 support for legacy code
# - Compatible with Stalin's 2006-era assumptions
# - Long-term support until 2025
#
# Key features:
# - Cross-platform build support (AMD64/ARM64)
# - Modern C compiler with legacy code compatibility
# - All dependencies for Stalin + Boehm GC + X11 graphics
# - Automated testing and build verification
#
# Author: Claude Code Development Team
# Date: 2024
# License: Same as Stalin (GNU GPL v2)

# Use Ubuntu 22.04 LTS as base - more modern, better ARM64 support
FROM ubuntu:22.04

# Prevent package installation from prompting for user input
# This is essential for automated Docker builds
ENV DEBIAN_FRONTEND=noninteractive

#
# DEVELOPMENT DEPENDENCIES INSTALLATION
# =====================================
# Install all packages needed to build Stalin, including:
# - C/C++ compilation tools
# - Build system utilities (make, autotools)
# - X11/OpenGL development libraries
# - Python for our fix scripts

# Architecture-aware package installation
# gcc-multilib is only available on AMD64, not ARM64
RUN apt-get update && \
    ARCH=$(dpkg --print-architecture) && \
    echo "Installing packages for architecture: $ARCH" && \
    # Install 32-bit development support on AMD64 systems
    if [ "$ARCH" = "amd64" ]; then \
        apt-get install -y gcc-multilib libc6-dev-i386; \
        echo "Added 32-bit development support"; \
    fi && \
    # Install core development packages (available on all architectures)
    apt-get install -y \
    # C/C++ Compilers - Use default GCC (11.x in Ubuntu 22.04)
    gcc \
    g++ \
    # Build system tools
    make \
    build-essential \
    autotools-dev \
    autoconf \
    libtool \
    pkg-config \
    # X11/Graphics development libraries (for Stalin's graphics support)
    libx11-dev \
    libxext-dev \
    libxmu-dev \
    libxi-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    freeglut3-dev \
    # System utilities
    wget \
    tar \
    gzip \
    file \
    patch \
    # Python for our fix scripts
    python3 \
    python3-pip \
    # Clean up package cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

#
# COMPILER CONFIGURATION
# =====================
# Compiler is already set up in Ubuntu 22.04
RUN gcc --version && \
    echo "Using default GCC compiler"

#
# WORKSPACE SETUP
# ==============
# Create the Stalin development workspace

# Set working directory for all operations
WORKDIR /stalin

# Copy Stalin source code into the container
# The .dockerignore file controls what gets copied
COPY . .

#
# BUILD SCRIPT PERMISSIONS
# =======================
# Make all our build scripts executable

RUN chmod +x build build-simple build-modern build-gl-fpi make-clean post-make test-docker.sh && \
    chmod +x include/stalin-architecture-name && \
    # Make benchmark scripts executable (may not exist in all distributions)
    find benchmarks -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true && \
    echo "Set executable permissions on build scripts"

#
# ENVIRONMENT VARIABLES
# ====================
# Set default compilation flags for Stalin builds

# C compiler flags optimized for Stalin
# -O2: Moderate optimization (good balance of speed and stability)
# -fno-strict-aliasing: Disable pointer aliasing optimizations (safer for legacy code)
# -std=c99: Use C99 standard (Stalin predates this but is mostly compatible)
ENV CFLAGS="-O2 -fno-strict-aliasing -std=c99"

# Linker flags - keep minimal for compatibility
ENV LDFLAGS=""

#
# BUILD ARTIFACTS DIRECTORY
# ========================
# Create directory for storing build outputs

RUN mkdir -p /stalin/build-artifacts && \
    echo "Created build artifacts directory"

#
# CONTAINER ENTRY POINT
# ====================
# By default, run our automated test script when container starts

CMD ["./test-docker.sh"]

#
# USAGE EXAMPLES
# =============
#
# Build the development environment:
#   docker build -t stalin-dev .
#
# Run automated tests:
#   docker run --rm stalin-dev
#
# Interactive development shell:
#   docker run -it --rm stalin-dev /bin/bash
#
# Build Stalin manually:
#   docker run --rm stalin-dev ./build-simple
#   docker run --rm stalin-dev ./build-modern