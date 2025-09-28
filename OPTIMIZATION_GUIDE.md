# Stalin Scheme Compiler Optimization Guide

## Overview

The Stalin Scheme compiler now includes advanced optimization capabilities through the `optimize-build.sh` script and support for the Cosmopolitan toolchain's various build modes.

## Quick Start

```bash
# Standard optimized build
./optimize-build.sh program.sc

# Maximum performance
./optimize-build.sh -O3 program.sc

# Minimal binary size
./optimize-build.sh -Os -m tiny -s program.sc

# Debug build
./optimize-build.sh -m debug -v program.sc
```

## Optimization Levels

### Standard GCC/Cosmopolitan Levels

- **`-O0`**: No optimization, fastest compilation, best for debugging
- **`-O1`**: Basic optimization, reasonable compile time
- **`-O2`**: Recommended default, good balance of speed and size
- **`-O3`**: Maximum optimization, may increase binary size
- **`-Os`**: Optimize for size, good for embedded systems
- **`-Oz`**: Aggressive size optimization (Clang)
- **`-Ofast`**: O3 + fast math, breaks strict standards compliance

### Build Modes

#### Standard Mode (default)
```bash
./optimize-build.sh program.sc
```
- Full Cosmopolitan runtime
- Cross-platform compatibility
- Debugging features available
- Binary size: ~400KB minimum

#### Tiny Mode (`-m tiny`)
```bash
./optimize-build.sh -m tiny program.sc
```
- Minimal runtime, no tracing
- ~50-70% size reduction
- Reduced features for smaller binaries
- Binary size: ~150-200KB
- Trade-offs: No ftrace/strace, reduced malloc performance

#### Debug Mode (`-m debug`)
```bash
./optimize-build.sh -m debug program.sc
```
- `-O0 -g` compilation
- Enhanced runtime checks
- Lock cycle detection
- UBSAN enabled in runtime
- Best for development

#### OptLinux Mode (`-m optlinux`)
```bash
./optimize-build.sh -m optlinux program.sc
```
- Linux-only optimized build
- Red zone optimization
- No Windows polyfills
- ~5% performance improvement
- Smallest Linux binaries

## Architecture Targeting

### Native Optimization
```bash
./optimize-build.sh -a native program.sc
```
Uses `-march=native` for CPU-specific optimizations.

### Cross-Architecture
```bash
# x86-64 baseline
./optimize-build.sh -a x86-64 program.sc

# ARM v8
./optimize-build.sh -a armv8-a program.sc

# Universal (default)
./optimize-build.sh -a universal program.sc
```

## Binary Stripping

Use `-s` flag to strip debug symbols:
```bash
./optimize-build.sh -Os -s program.sc
```

For tiny mode, this extracts the raw APE:
```bash
./optimize-build.sh -m tiny -s program.sc  # Creates smallest possible binary
```

## Performance Benchmarking

### Running Benchmarks

```bash
# Compile and run Fibonacci benchmark
./optimize-build.sh -O3 benchmark-fib.sc
./benchmark-fib

# Compare optimization levels
for opt in 0 2 3 s fast; do
    ./optimize-build.sh -O$opt benchmark-fib.sc -o bench-$opt
    time ./bench-$opt
done
```

### Benchmark Suite

The `benchmarks.sc` file includes:
- Fibonacci (recursive performance)
- Factorial (tail recursion)
- Prime Sieve (array operations)
- Matrix Multiplication (floating-point)
- List Operations (functional programming)
- Ackermann (deep recursion)
- Quicksort (general algorithm)

## Size Optimization Techniques

### Minimize Binary Size
1. Use tiny mode: `-m tiny`
2. Optimize for size: `-Os` or `-Oz`
3. Strip symbols: `-s`
4. Disable unused features in Stalin

Example for smallest binary:
```bash
./optimize-build.sh -Oz -m tiny -s program.sc
```

### Typical Size Comparisons

| Mode | Optimization | Stripped | Typical Size |
|------|-------------|----------|--------------|
| Standard | -O2 | No | ~400KB |
| Standard | -O2 | Yes | ~350KB |
| Tiny | -Os | No | ~200KB |
| Tiny | -Os | Yes | ~150KB |
| OptLinux | -O3 | Yes | ~180KB |

## Performance Tips

### General Recommendations

1. **Default Build**: Use `-O2` for general purpose
2. **Numeric Code**: Use `-O3` or `-Ofast`
3. **Large Programs**: Consider `-O2` over `-O3` (better cache usage)
4. **Embedded/IoT**: Use `-Os -m tiny`

### Stalin-Specific Optimizations

Stalin performs aggressive whole-program optimization:
- Type inference eliminates runtime checks
- Inlining across module boundaries
- Dead code elimination
- Representation optimization

To maximize Stalin's optimizations:
1. Avoid dynamic features when possible
2. Use type-specific operations
3. Enable Stalin's optimizer: `-On`

### Profiling Builds

For performance analysis:
```bash
# Debug build with symbols
./optimize-build.sh -m debug -v program.sc

# Run with profiling (if supported)
./program.com.dbg  # Use debug ELF for gdb
```

## Troubleshooting

### Build Failures

Enable verbose mode to see compilation commands:
```bash
./optimize-build.sh -v program.sc
# Check build-$$.log for details
```

### Performance Issues

1. Verify optimization level: `-O2` or `-O3`
2. Check architecture targeting: `-a native`
3. Consider mode trade-offs
4. Profile with debug builds

### Size Issues

1. Use tiny mode: `-m tiny`
2. Enable stripping: `-s`
3. Try `-Os` or `-Oz`
4. Consider optlinux for Linux-only

## Examples

### Web Server
```bash
# Optimized for throughput
./optimize-build.sh -O3 -a native webserver.sc
```

### Embedded Device
```bash
# Minimal size, reasonable performance
./optimize-build.sh -Os -m tiny -s embedded.sc
```

### Development
```bash
# Fast compilation, good debugging
./optimize-build.sh -O0 -m debug -v myapp.sc
```

### Distribution
```bash
# Universal binary, balanced
./optimize-build.sh -O2 -s myapp.sc
```

## Advanced Usage

### Custom Flags

Set environment variables for additional control:
```bash
export BUILDLOG=build.log
export CFLAGS="-march=znver2 -mtune=znver2"
./optimize-build.sh program.sc
```

### Integration with Build Systems

Makefile example:
```makefile
STALIN_OPT ?= ./optimize-build.sh
OPT_LEVEL ?= 2
MODE ?= standard

%.bin: %.sc
    $(STALIN_OPT) -O$(OPT_LEVEL) -m $(MODE) -o $@ $<

release: MODE=tiny
release: OPT_LEVEL=s
release: myapp.bin
    strip myapp.bin
```

## Architecture Support

Stalin now supports 15 architectures:
- **x86**: IA32, IA32-align-double, AMD64
- **ARM**: ARM (32-bit), ARM64 (64-bit) ✨ NEW
- **RISC-V**: RISCV64 ✨ NEW
- **PowerPC**: PowerPC, PowerPC64
- **SPARC**: SPARC, SPARCv9, SPARC64
- **Others**: MIPS, Alpha, M68K, S390
- **Universal**: Cosmopolitan

Compile for specific architecture:
```bash
./compile program.sc ARM64
./compile program.sc RISCV64
```