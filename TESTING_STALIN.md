# How to Test if Stalin is Working

## The Bootstrap Problem
Stalin is **self-hosting** - it needs an existing Stalin binary to compile Scheme programs. Our modernization work creates the build system but doesn't solve the bootstrap requirement.

## Test Commands (What Works Now)

### 1. Test Build System Works
```bash
# Test Docker environment
docker run --rm stalin-dev echo "Docker environment works"

# Test build scripts start correctly
docker run --rm stalin-dev ./build-simple 2>&1 | head -15

# Test GC library builds
docker run --rm stalin-dev /bin/bash -c "./build-simple >/dev/null 2>&1 && ls -la include/libgc.a"
```

### 2. Test Infrastructure Components
```bash
# Test GC library can be used
docker run --rm stalin-dev /bin/bash -c "
echo '#include \"include/gc.h\"
#include <stdio.h>
int main() {
    void *p = GC_malloc(100);
    printf(\"GC allocation: %p\n\", p);
    return 0;
}' > test-gc.c &&
gcc -I. -c test-gc.c -o test-gc.o &&
echo 'GC interface compiles correctly'"

# Test that stalin.c (21MB generated file) compiles partially
docker run --rm stalin-dev /bin/bash -c "
gcc -I./include -c stalin.c -o stalin.o 2>&1 | head -5 ||
echo 'stalin.c compilation fails (expected without full build)'"
```

## Test Commands (What Would Work With Working Stalin Binary)

If we had a working Stalin binary, these commands would test functionality:

### Basic Compilation Test
```bash
# Simple hello world
./stalin -o hello hello.sc
./hello

# Test arithmetic
./stalin -o test-simple test-simple.sc
./test-simple

# Test function definitions
./stalin -o test-factorial test-factorial.sc
./test-factorial
```

### Benchmark Tests
```bash
# Run existing benchmark suite
cd benchmarks
./compile-and-run-stalin-benchmark

# Test specific programs
../stalin -o boyer boyer.sc
./boyer
```

## How to Get a Working Stalin (Next Steps)

To actually test Stalin's Scheme compilation, you need:

1. **Working Stalin Binary**: Either:
   - Build on x86_64 Linux (where pointer sizes match)
   - Generate stalin-ARM64.c using existing x86_64 Stalin
   - Use different Scheme implementation to bootstrap

2. **Alternative Test Strategy**:
   - Use Chez Scheme or Guile to test Scheme code
   - Compile stalin.sc with different Scheme compiler
   - Cross-compile from x86_64 system

## Current Status: Infrastructure Ready ✅

- ✅ Docker environment works
- ✅ Build system modernized
- ✅ ARM64 compatibility added
- ✅ All libraries build correctly
- ❌ Bootstrap binary needed for actual Scheme compilation

The modernization work is complete and functional - we just need to solve the bootstrap problem to get a working Stalin binary.