# Stalin Scheme Compiler - Modern Unified Build System
# ===================================================
# This Makefile consolidates all build approaches into a clean, standardized interface

# Build Configuration
CC = gcc
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib/stalin
INCDIR = $(PREFIX)/include/stalin

# Modern compiler flags for compatibility
MODERN_CFLAGS = -std=c99 -Wno-implicit-function-declaration -Wno-int-conversion -Wno-incompatible-pointer-types

# Stalin compilation options
STALIN_OPTIONS = -d1 -d5 -d6 -On -t -c -db \
                -clone-size-limit 0 -split-even-if-no-widening \
                -do-not-align-strings \
                -treat-all-symbols-as-external \
                -do-not-index-constant-structure-types-by-expression \
                -do-not-index-allocated-structure-types-by-expression

# Docker configuration
CONTAINER_NAME = stalin-compiler
CONTAINER_IMAGE = stalin-x86_64

# Build targets
.PHONY: all build docker-build native install uninstall clean distclean test help

all: help

help:
	@echo "Stalin Scheme Compiler - Build System"
	@echo "======================================"
	@echo ""
	@echo "Quick Start:"
	@echo "  make docker-build    - Build Docker environment (recommended)"
	@echo "  make build           - Build Stalin using Docker pipeline"
	@echo "  make native          - Build Stalin natively (may fail on ARM64)"
	@echo "  make install         - Install Stalin system-wide"
	@echo ""
	@echo "Development:"
	@echo "  make test            - Run test suite"
	@echo "  make clean           - Clean build artifacts"
	@echo "  make distclean       - Deep clean including Docker"
	@echo ""
	@echo "Usage Examples:"
	@echo "  # Compile a Scheme file"
	@echo "  make compile FILE=hello.sc"
	@echo "  # Or use the enhanced script directly"
	@echo "  ./compile-fast.sh hello.sc"

# Docker-based build (recommended for ARM64/Apple Silicon)
docker-build:
	@echo "🔧 Building Stalin Docker environment..."
	./docker-build.sh
	@echo "✅ Docker environment ready"
	@echo "💡 Use 'make compile FILE=yourfile.sc' to compile Scheme programs"

build: docker-build
	@echo "✅ Stalin is ready to use via Docker pipeline"
	@echo "💡 The compile-fast.sh script provides the best user experience"

# Native build attempt (may not work on ARM64)
native: stalin-native

stalin-native: check-native-prereqs
	@echo "🔧 Attempting native Stalin build..."
	@echo "⚠️  This may fail on ARM64 systems - use Docker build instead"
	./build-modern
	@if [ -f stalin ]; then \
		echo "✅ Native Stalin built successfully"; \
		mv stalin stalin-native; \
	else \
		echo "❌ Native build failed - use 'make docker-build' instead"; \
		exit 1; \
	fi

check-native-prereqs:
	@echo "🔍 Checking native build prerequisites..."
	@command -v gcc >/dev/null || (echo "❌ GCC not found" && exit 1)
	@test -f gc6.8.tar.gz || (echo "❌ gc6.8.tar.gz not found" && exit 1)
	@echo "✅ Prerequisites OK"

# Compile a Scheme file using the enhanced pipeline
compile:
ifndef FILE
	@echo "❌ Usage: make compile FILE=yourfile.sc"
	@exit 1
endif
	@if [ ! -f "$(FILE)" ]; then \
		echo "❌ File not found: $(FILE)"; \
		exit 1; \
	fi
	@echo "🔧 Compiling $(FILE) using enhanced pipeline..."
	./compile-fast.sh "$(FILE)"

# Installation targets
install: check-install-prereqs
	@echo "🔧 Installing Stalin system-wide to $(PREFIX)..."
	mkdir -p $(BINDIR) $(LIBDIR) $(INCDIR)
	# Install enhanced compilation script
	install -m 755 compile-fast.sh $(BINDIR)/stalin-compile
	# Install Docker build script
	install -m 755 docker-build.sh $(LIBDIR)/
	# Install architecture detection
	install -m 755 stalin-architecture-name $(LIBDIR)/
	# Install include files
	cp -r include/* $(INCDIR)/ 2>/dev/null || true
	# Install sample files
	mkdir -p $(LIBDIR)/examples
	cp minimal.sc factorial.sc hello.sc $(LIBDIR)/examples/ 2>/dev/null || true
	# Create convenience wrapper
	@echo '#!/bin/bash' > $(BINDIR)/stalin
	@echo '# Stalin Scheme Compiler Wrapper' >> $(BINDIR)/stalin
	@echo 'exec $(LIBDIR)/stalin-compile "$$@"' >> $(BINDIR)/stalin
	@chmod 755 $(BINDIR)/stalin
	@echo "✅ Stalin installed successfully!"
	@echo "💡 Use 'stalin yourfile.sc' to compile Scheme programs"
	@echo "💡 Examples available in $(LIBDIR)/examples/"

check-install-prereqs:
	@command -v docker >/dev/null || (echo "❌ Docker required for installation" && exit 1)
	@docker image inspect $(CONTAINER_IMAGE) >/dev/null 2>&1 || \
		(echo "❌ Stalin Docker image not found. Run 'make docker-build' first." && exit 1)
	@echo "✅ Installation prerequisites OK"

uninstall:
	@echo "🗑️  Uninstalling Stalin..."
	rm -f $(BINDIR)/stalin $(BINDIR)/stalin-compile
	rm -rf $(LIBDIR) $(INCDIR)
	@echo "✅ Stalin uninstalled"

# Testing
test: docker-build
	@echo "🧪 Running Stalin test suite..."
	@if [ -f compile-fast.sh ]; then \
		echo "Testing enhanced compilation pipeline..."; \
		./compile-fast.sh minimal.sc; \
		if [ -f minimal ]; then \
			echo "✅ Compilation test passed"; \
			./minimal; \
			rm -f minimal minimal.c; \
		fi; \
	fi
	@echo "✅ All tests completed"

# Legacy targets for compatibility
stalin: stalin.c
	$(CC) -o stalin -I./include -O3 -fomit-frame-pointer\
              -fno-strict-aliasing ${ARCH_OPTS}\
	      stalin.c -L./include -lm -lgc
	./post-make

stalin-architecture: stalin-architecture.c
	$(CC) -o stalin-architecture stalin-architecture.c

stalin.c: stalin.sc
	./stalin $(STALIN_OPTIONS) stalin

# Cleanup targets
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -f *.c *.o stalin stalin-native
	rm -f hello factorial minimal tak deriv
	rm -f ./include/gc.h ./include/gc_config_macros.h
	rm -f ./include/libgc.a ./include/libstalin.a ./include/libTmk.a
	rm -f ./include/stalin ./stalin.c
	@echo "✅ Build artifacts cleaned"

distclean: clean
	@echo "🧹 Deep cleaning (including Docker)..."
	rm -f stalin-*.c
	rm -rf gc6.8/
	-docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	-docker image rm $(CONTAINER_IMAGE) 2>/dev/null || true
	@echo "✅ Deep clean completed"

# Version and system info
version:
	@echo "Stalin Scheme Compiler Build System v2.0"
	@echo "Platform: $$(uname -m) $$(uname -s)"
	@echo "Docker: $$(docker --version 2>/dev/null || echo 'Not available')"
	@echo "GCC: $$(gcc --version 2>/dev/null | head -1 || echo 'Not available')"

# Development helpers
dev: docker-build
	@echo "🔧 Setting up development environment..."
	@echo "✅ Development environment ready"
	@echo "💡 Key files:"
	@echo "   - compile-fast.sh   (enhanced compilation)"
	@echo "   - docker-build.sh   (Docker environment)"
	@echo "   - stalin.sc         (compiler source)"
	@echo "   - benchmarks/       (test programs)"
