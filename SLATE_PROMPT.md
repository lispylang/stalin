# Slate Branch: Stalin Cosmopolitan Libc Port

## Mission Statement

I want to port the Stalin Scheme compiler to use Justine Tunney's Cosmopolitan Libc to make it truly portable. The goal is to replace the current architecture-specific C generation with a single portable binary that runs on Linux, Mac, Windows, FreeBSD, OpenBSD, and NetBSD.

Please create a new branch called 'slate' for these changes. The existing codebase already has extensive modifications from the original Stalin 0.11.

## Current Codebase State

### Already Completed Modifications

#### 1. Docker-Based Build System
- **Added Docker infrastructure:**
  - `Dockerfile` and `Dockerfile.x86_64` for containerized builds using Ubuntu 22.04
  - `docker-build.sh` and `docker-test.sh` scripts for consistent cross-platform compilation
  - Implemented Docker-based compilation pipeline that uses x86_64 emulation on ARM64 hosts
- **Simplified compilation:**
  - `compile` script (renamed from `compile-simple.sh`) handles Docker-based compilation with architecture selection
  - One-command compilation: `./compile program.sc [architecture]`

#### 2. Architecture Support Enhancements
- **Pre-compiled Stalin C files generated:**
  - `stalin-IA32.c` - 32-bit x86
  - `stalin-AMD64.c` - 64-bit x86
  - `stalin-ARM64.c` - ARM 64-bit (Apple Silicon)
- **Architecture validation framework:**
  - 13 architecture test files (`*-test.c`): AMD64, ARM, Alpha, IA32, IA32-align-double, M68K, MIPS, PowerPC, PowerPC64, S390, SPARC, SPARC64, SPARCv9
  - `test-architectures.sh` for systematic architecture testing
  - `generate-stalin-c.sh` for bootstrap C file generation
  - `test-baseline.c` for architecture validation
- **Documentation:**
  - `ARCHITECTURE_SUPPORT.md` documents all 13 supported architectures with test results

#### 3. Build Scripts Modernization
- **Simplified build system:**
  - Core scripts: `build`, `build-simple`, `build-modern`
  - Specialized scripts: `build-gc-arm64.sh`, `build-Tmk`, `build-gl-fpi`
- **Cleanup performed:**
  - Removed obsolete build artifacts and scripts
  - Streamlined build process for modern systems

#### 4. Documentation Updates
- **Modern documentation:**
  - `README.md` - Quick start guide with platform support matrix
  - `README.original` - Preserved original Stalin documentation
  - `USAGE.md` - Detailed usage examples
  - `LISPY_ROADMAP.md` - Development planning document
  - `ARCHITECTURE_SUPPORT.md` - Comprehensive architecture documentation
- **Focus on usability:**
  - Clear examples and quick start instructions
  - Docker-based workflow for consistency

#### 5. Repository Organization
- **Directory structure:**
  ```
  /
  ├── benchmarks/       # Benchmark programs and tests
  ├── include/          # C include files (gl-c.c, xlib-c.c)
  ├── source/           # Additional source files
  ├── *.sc             # Scheme source files
  ├── stalin-*.c       # Pre-compiled Stalin C files
  ├── *-test.c         # Architecture test files
  └── build scripts    # Various build and test scripts
  ```
- **Version control:**
  - Proper `.gitignore` and `.dockerignore` files
  - Clean git history with semantic commit messages

#### 6. Core Files Retained
- **Scheme sources:**
  - `stalin.sc` - Main compiler source (1.1MB)
  - `QobiScheme.sc` - QobiScheme library (191KB)
  - `parallel-QobiScheme.sc` - Parallel version
  - `gl.sc`, `xlib.sc`, `xlib-minimal.sc` - Graphics libraries
  - Helper utilities: `lenin.sc`, `remove-extra-blank-lines.sc`, `Tmk.sc`
- **Architecture definitions:**
  - `stalin.architectures` - Unchanged from original, defines all architecture parameters
- **Test programs:**
  - `hello.sc` - Simple test program
  - `benchmarks/` directory with various benchmark programs

#### 7. Current Working State
- **Functional compilation pipeline:**
  - Successfully compiles Scheme programs on macOS ARM64 via Docker x86_64 emulation
  - Generates architecture-specific C code for all 13 supported architectures
  - Native compilation of generated C code works on host platform
- **Testing infrastructure:**
  - Complete testing framework for architecture validation
  - All 13 architectures tested and confirmed working for C generation
- **Platform support:**
  - macOS (Intel and Apple Silicon) - Fully working
  - Linux x86_64 - Fully working
  - Windows WSL2 - In testing

## Cosmopolitan Libc Port Requirements

### Primary Goals
1. **Single portable binary** that runs on all major operating systems
2. **Eliminate architecture-specific C files** (stalin-IA32.c, stalin-AMD64.c, stalin-ARM64.c)
3. **Remove Docker dependency** for compilation
4. **Maintain Stalin's optimization capabilities** while using Cosmopolitan

### Technical Considerations

#### Architecture Abstraction
- Stalin currently generates architecture-specific C code based on `stalin.architectures`
- Each architecture defines:
  - Data type mappings (char, int, float, double)
  - Alignment requirements
  - Size specifications
  - Compiler flags
- Need to create a "Cosmopolitan" architecture target that works universally

#### Files to Modify
1. **stalin.architectures**
   - Add new "Cosmopolitan" architecture definition
   - Define universal type mappings that work with Cosmopolitan

2. **stalin.sc**
   - Modify code generation to support Cosmopolitan's portable format
   - Adapt runtime system for Cosmopolitan's libc

3. **Build scripts**
   - Update `compile` script to support Cosmopolitan compilation
   - Modify build scripts to use Cosmopolitan toolchain

4. **C runtime files**
   - Replace architecture-specific stalin-*.c files with universal version
   - Adapt include files for Cosmopolitan headers

### Implementation Strategy

#### Phase 1: Research and Planning
- Study Cosmopolitan Libc's requirements and capabilities
- Identify Stalin's architecture-dependent code sections
- Plan the abstraction layer for universal binary generation

#### Phase 2: Cosmopolitan Architecture Target
- Add "Cosmopolitan" to stalin.architectures
- Define universal type system compatible with Cosmopolitan
- Test basic C code generation with new target

#### Phase 3: Runtime Adaptation
- Port Stalin's runtime system to Cosmopolitan Libc
- Replace platform-specific system calls with Cosmopolitan equivalents
- Handle file I/O, memory management, and signal handling

#### Phase 4: Build System Integration
- Integrate Cosmopolitan toolchain into build process
- Create new build script for Cosmopolitan compilation
- Update compile script to support new target

#### Phase 5: Testing and Validation
- Test generated binaries on all target platforms
- Verify optimization levels are maintained
- Benchmark against Docker-based compilation

### Challenges to Address

1. **Type System Compatibility**
   - Stalin's aggressive type inference relies on precise architecture knowledge
   - Need to ensure Cosmopolitan's universal types don't compromise optimization

2. **Memory Management**
   - Stalin uses Boehm GC which may need adaptation for Cosmopolitan
   - Ensure garbage collection works across all platforms

3. **Graphics Libraries**
   - Stalin includes X11/OpenGL support (gl.sc, xlib.sc)
   - May need to disable or adapt for Cosmopolitan's capabilities

4. **Signal Handling**
   - Stalin uses setjmp/longjmp for control flow
   - Verify compatibility with Cosmopolitan's signal handling

### Success Criteria

1. **Single binary** compiles and runs on Linux, macOS, Windows, FreeBSD, OpenBSD, NetBSD
2. **No Docker required** for compilation
3. **Performance parity** with architecture-specific builds (within 10%)
4. **All benchmarks pass** on all platforms
5. **Simplified user experience** - just `./stalin program.sc`

## Development Notes

### Partial/In-Progress Work
- ARM64 native support exists but still relies on Docker for initial compilation
- Windows WSL2 support is marked as 'Testing' status
- Cross-compilation toolchain setup not fully documented

### Key Resources
- [Cosmopolitan Libc](https://github.com/jart/cosmopolitan)
- [Stalin Original Documentation](README.original)
- [Architecture Support Details](ARCHITECTURE_SUPPORT.md)
- [Current Build System](README.md)

### Branch Strategy
1. Create 'slate' branch from current master
2. Preserve working Docker-based system in master
3. Iteratively port to Cosmopolitan in slate branch
4. Merge back to master once fully functional

---

*This document serves as the comprehensive prompt for implementing the Cosmopolitan Libc port of Stalin in the 'slate' branch.*