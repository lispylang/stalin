# Stalin Scheme Compiler - Development Guide

## Quick Start with Docker

### 1. Build the Development Environment

```bash
# Build the Docker development environment
./docker-build.sh

# Or manually:
docker build -t stalin-dev .
```

### 2. Run Development Environment

```bash
# Interactive development shell
docker run -it --rm -v $(pwd):/stalin stalin-dev /bin/bash

# Run automated test (default)
docker run -it --rm -v $(pwd):/stalin stalin-dev

# Build and test manually
docker run -it --rm -v $(pwd):/stalin stalin-dev ./build-modern
```

## Build Scripts

- `build` - Original build script (may fail on modern systems)
- `build-modern` - Enhanced build script with compatibility fixes
- `makefile.modern` - Updated makefile with modern compiler flags
- `test-docker.sh` - Automated testing script

## Architecture Support Status

| Architecture | Status | Notes |
|--------------|--------|-------|
| IA32 (x86)   | ✅ Working | Primary target, pre-generated C code available |
| AMD64        | 🔄 In Progress | Requires testing and validation |
| ARM64        | 🔄 Planned | Modern Apple Silicon / ARM64 support |
| Alpha        | ⚠️ Legacy | Historical support, may work |
| SPARC        | ⚠️ Legacy | Historical support, may work |
| MIPS         | ⚠️ Legacy | Historical support, may work |
| PowerPC      | ⚠️ Legacy | Historical support, may work |

## Key Improvements Made

### 1. Docker Environment
- Ubuntu 20.04 base with GCC 7.x
- All necessary development dependencies
- Automated testing workflow

### 2. Build System Modernization
- Enhanced architecture detection
- Modern compiler flag compatibility
- Better error handling and fallbacks
- C99 standard compliance flags

### 3. Compatibility Fixes
- Fixed Boehm GC compilation issues
- Added modern C compiler warnings suppression
- Improved cross-platform build support
- Enhanced dependency management

## Development Workflow

### Phase 1: Foundation (Current)
1. ✅ Docker development environment
2. ✅ Basic build system fixes
3. ✅ Legacy compatibility layer
4. 🔄 Initial compilation testing

### Phase 2: Modernization (Next)
1. 🔄 Full 64-bit architecture support
2. 🔄 ARM64 architecture implementation
3. 🔄 Build system conversion to CMake
4. 🔄 Automated testing pipeline

### Phase 3: Enhancement (Future)
1. ⏳ Modern Scheme standards support
2. ⏳ Enhanced foreign function interface
3. ⏳ Developer tooling improvements
4. ⏳ Performance optimizations

## Testing

```bash
# Run in Docker environment
docker run -it --rm -v $(pwd):/stalin stalin-dev ./test-docker.sh

# Test specific components
cd benchmarks
./compile-and-run-stalin-benchmarks
```

## Known Issues

1. **ARM64 Architecture**: Currently uses IA32 fallback
2. **Pointer Alignment**: May have issues on 64-bit systems
3. **Legacy Dependencies**: Some X11/OpenGL components may be outdated
4. **Self-Hosting Bootstrap**: Requires working Stalin to build Stalin

## Contributing

1. All development should use the Docker environment for consistency
2. Test changes against the benchmark suite
3. Maintain backward compatibility where possible
4. Document architectural changes and limitations

## File Structure

```
stalin/
├── build-modern          # Enhanced build script
├── makefile.modern       # Modern makefile
├── Dockerfile            # Development environment
├── test-docker.sh        # Automated testing
├── source/               # Scheme source files
├── include/              # C headers and libraries
├── benchmarks/           # Test programs
└── stalin.sc             # Main compiler source (32K+ lines)
```

## Next Steps

1. Validate Docker environment compilation
2. Create ARM64 architecture support
3. Implement CMake build system
4. Set up automated CI/CD pipeline
5. Begin modern Scheme standards implementation