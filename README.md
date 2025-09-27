# Stalin: A Modern Scheme Compiler

**Stalin** is an aggressively optimizing Scheme compiler that produces highly efficient native code. This modernized version works seamlessly on ARM64/Apple Silicon through a hybrid Docker compilation pipeline.

> 📜 **Original Documentation**: See [README.original](README.original) for the historical Stalin documentation by Jeffrey Mark Siskind.

## 🚀 Quick Start

**Compile any Scheme program in one command:**

```bash
./compile your-program.sc
./your-program
```

### Examples

```bash
# Hello World
echo '(display "Hello, World!")' > hello.sc
./compile hello.sc
./hello

# Try benchmarks
./compile benchmarks/boyer.sc
time ./boyer
```

### How it Works

The compilation pipeline automatically:
1. Uses Docker x86_64 emulation for Stalin's code generation (stable)
2. Compiles the generated C code natively on your system (optimal)
3. Creates optimized native binaries

## 🛠️ Development Setup

### Prerequisites
- **Docker Desktop** (required for compilation)
- **GCC/Clang** (for native compilation)

### Setup
```bash
# Build Docker environment (one-time setup)
./docker-build.sh

# Interactive development
docker run -it --rm -v $(pwd):/stalin stalin-dev /bin/bash
```

### Alternative: Local Build
```bash
# Build Stalin locally (warnings expected on ARM64)
./build-simple

# Or full build with Boehm GC
./build-modern
```

## 📖 Usage

See [USAGE.md](USAGE.md) for detailed examples and advanced usage.

## 🎓 About Stalin

Stalin is a whole-program optimizing Scheme compiler created by Jeffrey Mark Siskind. It performs aggressive optimizations including:

- **Global type inference**: Eliminates runtime type checks
- **Representation selection**: Uses unboxed native types
- **Lifetime analysis**: Reduces garbage collection
- **Dead code elimination**: Removes unused code
- **Closure optimization**: Efficient closure compilation

### Key Features
- Produces standalone executables
- No runtime interpreter needed
- Extremely fast numeric code
- Small binary size
- R4RS Scheme (mostly) compatible

## 🏗️ Platform Support

### Host Platforms (where Stalin runs)
| Platform | Architecture | Status | Method |
|----------|-------------|--------|---------|
| macOS | Apple Silicon (ARM64) | ✅ Working | `compile` |
| macOS | Intel (x86_64) | ✅ Working | `compile` |
| Linux | x86_64 | ✅ Working | `compile` |
| Windows | WSL2 | 🔧 Testing | Docker required |

### Target Architectures (what Stalin compiles for)
Stalin can generate optimized C code for **13 different architectures**:

| Architecture | Status | Usage Example |
|--------------|--------|---------------|
| **AMD64** (x86_64) | ✅ Tested | `./compile hello.sc AMD64` |
| **IA32** (x86 32-bit) | ✅ Tested | `./compile hello.sc IA32` |
| **ARM** (32-bit) | ✅ Tested | `./compile hello.sc ARM` |
| **PowerPC/PowerPC64** | ✅ Tested | `./compile hello.sc PowerPC` |
| **SPARC/SPARCv9/SPARC64** | ✅ Tested | `./compile hello.sc SPARC` |
| **Alpha, MIPS, M68K, S390** | ✅ Tested | `./compile hello.sc Alpha` |

📋 **Full Details**: See [ARCHITECTURE_SUPPORT.md](ARCHITECTURE_SUPPORT.md) for comprehensive architecture testing results and cross-compilation guidance.

## 🤝 Contributing

We welcome contributions! Priority areas:
1. **Platform expansion**: Windows WSL2 support
2. **Testing**: Expand benchmark coverage
3. **Documentation**: More examples and tutorials
4. **Modernization**: R7RS Scheme compatibility

## 📜 License

GNU General Public License v2 (inherited from original Stalin)

---

> "Stalin: Finally, a Lisp compiler that does what it should..."