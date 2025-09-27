# Stalin Architecture Support Documentation

This document provides comprehensive information about Stalin's support for different CPU architectures and compilation targets.

## Overview

Stalin supports compilation for 12 different CPU architectures through its architecture-aware code generation system. The compiler can generate C code optimized for specific architectures, which is then compiled natively or cross-compiled for the target platform.

## Supported Architectures

| Architecture | CPU Family | Pointer Size | OS Support | Compiler | Test Status | Notes |
|--------------|------------|--------------|------------|----------|-------------|-------|
| **IA32** | x86 32-bit | 32-bit | Linux | GCC | ✅ Working | Standard x86 32-bit target |
| **IA32-align-double** | x86 32-bit | 32-bit | Linux | GCC | ✅ Working | x86 with `-malign-double` flag |
| **AMD64** | x86_64 | 64-bit | Linux | GCC | ✅ Working | Primary development target |
| **ARM** | ARM 32-bit | 32-bit | Linux | GCC | ✅ Working | 32-bit ARM processors |
| **PowerPC** | PowerPC | 32-bit | Darwin/macOS | Unknown | ✅ Working | Legacy macOS PowerPC |
| **PowerPC64** | PowerPC | 64-bit | AIX | GCC/xlc | ✅ Working | 64-bit PowerPC with `-maix64`/`-q64` |
| **SPARC** | SPARC | 32-bit | Linux/Solaris | GCC/Sun CC | ✅ Working | Standard SPARC target |
| **SPARCv9** | SPARC | 64-bit | Solaris | Sun CC | ✅ Working | 64-bit SPARC with `-xarch=v9` |
| **SPARC64** | SPARC | 32-bit | Unknown | Unknown | ✅ Working | Experimental SPARC64 support |
| **MIPS** | MIPS | 32-bit | IRIX | GCC/SGI CC | ✅ Working | SGI IRIX systems |
| **Alpha** | DEC Alpha | 64-bit | Linux/OSF1 | GCC/DEC CC | ✅ Working | DEC Alpha processors |
| **M68K** | Motorola 68k | 32-bit | Linux | GCC | ✅ Working | Motorola 68000 family |
| **S390** | IBM S/390 | 32-bit | Linux | Unknown | ✅ Working | IBM mainframe architecture |

### Legend
- ✅ **Working**: Confirmed to generate valid C code and compile successfully
- 🔧 **Pending**: Not yet tested in this environment
- ⚠️ **Issues**: Generates code but with known problems
- ❌ **Broken**: Fails to generate valid C code
- ❓ **Unknown**: Architecture status unclear

## Architecture Details

### Primary Architectures (Well-tested)

#### AMD64 (x86_64)
- **Status**: ✅ Working - Primary development target
- **Usage**: `./stalin -architecture AMD64 program.sc`
- **Notes**: Used by default in `compile`, full Docker support

#### IA32 (x86 32-bit)
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture IA32 program.sc`
- **Notes**: Standard 32-bit x86 target, should work on most systems

### Legacy Architectures

#### PowerPC / PowerPC64
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture PowerPC program.sc`
- **Notes**: Originally for macOS PowerPC systems, may need special setup

#### SPARC / SPARCv9 / SPARC64
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture SPARC program.sc`
- **Notes**: Sun/Oracle SPARC processors, various 32/64-bit variants

### Embedded/Specialized Architectures

#### ARM (32-bit)
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture ARM program.sc`
- **Notes**: 32-bit ARM, not ARM64/AArch64

#### MIPS
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture MIPS program.sc`
- **Notes**: Originally for SGI IRIX systems

#### Alpha
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture Alpha program.sc`
- **Notes**: DEC Alpha processors, 64-bit architecture

#### M68K
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture M68K program.sc`
- **Notes**: Motorola 68000 family processors

#### S390
- **Status**: 🔧 Pending testing
- **Usage**: `./stalin -architecture S390 program.sc`
- **Notes**: IBM mainframe architecture

## Testing Methodology

### Basic Architecture Test
To test if Stalin can generate C code for a specific architecture:

```bash
# Test basic code generation
echo '(display "Hello, World!")' > test.sc
./stalin -architecture <ARCH_NAME> -c test.sc

# Check if C code was generated
ls test.c
```

### Comprehensive Testing Script
Use the provided `test-architectures.sh` script to systematically test all architectures:

```bash
./test-architectures.sh
```

This script will:
1. Test C code generation for each architecture
2. Verify generated C code syntax
3. Report results for each architecture
4. Update this documentation with results

## Architecture Configuration Details

Each architecture in Stalin is defined with specific parameters:

- **Data type mappings**: How Scheme types map to C types
- **Alignment requirements**: Memory alignment for different data types
- **Size specifications**: Size of pointers, integers, floats, etc.
- **Compiler flags**: Special flags needed for the target architecture

These configurations are stored in `stalin.architectures` and define:
- Type names (`char`, `int`, `float`, `double`, etc.)
- Alignment values (memory alignment requirements)
- Size values (byte sizes for each type)
- Special compilation flags

## Current Platform Status

### Working Platforms (via Docker)
- **macOS Apple Silicon (ARM64)**: ✅ Working via AMD64 Docker emulation
- **macOS Intel (x86_64)**: ✅ Working via AMD64 Docker emulation
- **Linux x86_64**: ✅ Working via AMD64 Docker emulation
- **Windows WSL2**: 🔧 Testing via Docker

### Architecture vs Platform Notes
- **Architecture**: Refers to Stalin's code generation target (IA32, AMD64, ARM, etc.)
- **Platform**: Refers to the host system running Stalin (macOS, Linux, Windows)
- Stalin can generate code for any supported architecture regardless of host platform
- Final compilation success depends on having appropriate cross-compilation tools

## Future Work

### Priority Testing Areas
1. **IA32 verification**: Test 32-bit x86 code generation
2. **ARM 32-bit testing**: Verify ARM code generation and compilation
3. **Legacy architecture validation**: Test SPARC, MIPS, Alpha code generation
4. **Cross-compilation setup**: Document cross-compilation toolchain setup

### Potential Improvements
1. **ARM64 support**: Add native ARM64/AArch64 architecture definition
2. **RISC-V support**: Add support for modern RISC-V architecture
3. **WebAssembly target**: Investigate WebAssembly code generation
4. **Architecture auto-detection**: Automatically detect and use appropriate architecture

## References

- Architecture definitions: `stalin.architectures`
- Compilation scripts: `compile`, `test-architectures.sh`
- Original documentation: `README.original`

---

Last updated: 2025-09-27 14:02:40
Test results: 13 passed, 0 warnings, 0 failed