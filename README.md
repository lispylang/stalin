# Stalin → Lispy: A Modern Scheme Compiler

**Stalin** is an aggressively optimizing Scheme compiler that produces highly efficient native code. This project aims to modernize Stalin for contemporary development environments and evolve it into **Lispy**, a next-generation Lisp development platform.

> 📜 **Original Documentation**: See [README.original](README.original) for the historical Stalin documentation by Jeffrey Mark Siskind.

## 🚀 Quick Start

### Using Docker (Recommended)

```bash
# Start Docker Desktop first!

# Build the development environment
./docker-build.sh

# Run interactive development
docker run -it --rm -v $(pwd):/stalin stalin-dev /bin/bash

# Run automated tests
docker run --rm stalin-dev
```

### Local Development (macOS/Linux)

```bash
# Build Stalin with modern fixes
./build-modern

# Or use the simplified build
./build-simple

# Test the compiler
./stalin hello.sc
./hello
```

## 📋 Project Status

### ✅ Phase 1: Modernization (In Progress)
- [x] Docker development environment
- [x] Modern build scripts
- [x] Initial compatibility fixes
- [ ] Complete Boehm GC integration
- [ ] Fix all compiler warnings

### 🔄 Phase 2: Architecture Support (Next)
- [ ] Native ARM64/Apple Silicon support
- [ ] Full 64-bit compatibility
- [ ] Windows WSL2 support
- [ ] Generate architecture-specific code

### 🎯 Phase 3: Lispy Transformation (Future)
- [ ] Modern Scheme standards (R7RS)
- [ ] Interactive REPL
- [ ] Package management system
- [ ] IDE integration
- [ ] Documentation generator

## 🏗️ Architecture Support

| Platform | Architecture | Status | Notes |
|----------|-------------|---------|-------|
| Linux | x86_64 | ✅ Working | Docker recommended |
| macOS | Intel (x86_64) | ✅ Working | Native build works |
| macOS | Apple Silicon (ARM64) | 🔧 In Progress | Falls back to x86 emulation |
| Windows | WSL2 | 🔧 Testing | Use Docker |

## 🛠️ Development

### Prerequisites

- **Docker Desktop** (recommended) or
- **Local tools**: GCC/Clang, Make, Python 3
- **For graphics**: X11 development libraries

### Project Structure

```
stalin/
├── stalin.sc           # Compiler source (32K+ lines)
├── stalin-*.c          # Pre-generated C code
├── build-modern        # Modern build script
├── Dockerfile          # Docker environment
├── benchmarks/         # Test programs
├── include/            # Runtime libraries
└── docs/              # Documentation (coming)
```

### Building from Source

```bash
# Extract Boehm GC
tar -xzf gc6.8.tar.gz

# Build GC for ARM64 (if on Apple Silicon)
./build-gc-arm64.sh

# Build Stalin
make -f makefile.modern

# Run tests
cd benchmarks
./run-tests.sh  # Coming soon
```

### Known Issues

1. **Docker daemon not running**: Start Docker Desktop first
2. **Missing libgc.a**: Run `./build-gc-arm64.sh`
3. **Build hangs**: Use `build-simple` instead of `build-modern`
4. **Pointer warnings**: Expected on 64-bit systems (being fixed)

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

### Limitations

- No interactive REPL
- No dynamic code loading
- Compilation can be slow
- Limited debugging support

## 🚧 Roadmap to Lispy

**Lispy** will evolve Stalin into a modern, developer-friendly Lisp platform:

### Near Term (2024 Q1)
- [ ] Complete ARM64 native support
- [ ] CMake build system
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Comprehensive test suite

### Medium Term (2024 Q2)
- [ ] Basic REPL functionality
- [ ] Module system
- [ ] Package manager integration
- [ ] VS Code extension

### Long Term (2024+)
- [ ] JIT compilation option
- [ ] Incremental compilation
- [ ] Advanced debugging tools
- [ ] Web assembly target
- [ ] GPU compute support

## 📖 Documentation

- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide
- [TESTING_STALIN.md](TESTING_STALIN.md) - Testing procedures
- [VALIDATION_RESULTS.md](VALIDATION_RESULTS.md) - Build validation
- [benchmarks/README](benchmarks/README) - Benchmark suite

## 🤝 Contributing

We welcome contributions! Priority areas:

1. **Architecture support**: Help with ARM64/M1/M2 native code generation
2. **Build system**: CMake conversion
3. **Testing**: Expand test coverage
4. **Documentation**: Tutorials and examples
5. **Modernization**: C99/C11 compliance

### Development Process

```bash
# 1. Fork and clone
git clone https://github.com/yourusername/stalin.git

# 2. Create feature branch
git checkout -b feature/amazing-feature

# 3. Use Docker for consistent environment
./docker-build.sh
docker run -it --rm -v $(pwd):/stalin stalin-dev

# 4. Make changes and test
./build-modern
./test-docker.sh

# 5. Submit PR with description
```

## 📜 License

GNU General Public License v2 (inherited from original Stalin)

## 🙏 Acknowledgments

- **Jeffrey Mark Siskind** - Original Stalin author
- **Contributors** - See README.original for historical contributors
- **Modern Team** - Working on the Lispy transformation

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/lispylang/stalin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/lispylang/stalin/discussions)
- **Legacy**: Bug-Stalin@AI.MIT.EDU (historical, may not be active)

---

> "Stalin: Finally, a Lisp compiler that does what it should..."
> *Evolving into Lispy: A Lisp that developers actually want to use.*

## Quick Reference

```scheme
;; Hello World in Stalin/Lispy
(display "Hello, World!")
(newline)

;; Compile and run
;; $ stalin hello.sc
;; $ ./hello
;; Hello, World!
```

For more examples, see the [benchmarks](benchmarks/) directory.