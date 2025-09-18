# Stalin/Lispy Quick Start Guide

## ⚡ Fastest Way to Start (Docker)

### Prerequisites
- **Docker Desktop** installed and running
- 4GB free disk space
- Basic command line knowledge

### 1. Start Docker Desktop
**Important**: Docker Desktop must be running before proceeding!
- **macOS**: Open Docker from Applications
- **Windows**: Start Docker Desktop from Start Menu
- **Linux**: `sudo systemctl start docker`

### 2. Build Development Environment
```bash
# Clone the repository (if you haven't)
git clone https://github.com/lispylang/stalin.git
cd stalin

# Build Docker environment
./docker-build.sh

# Or using docker-compose
docker-compose build
```

### 3. Enter Development Environment
```bash
# Interactive development shell
docker-compose run --rm stalin-dev

# Or traditional Docker
docker run -it --rm -v $(pwd):/stalin stalin-dev /bin/bash
```

### 4. Build Stalin Inside Container
```bash
# Inside the container
./build-modern

# Test the build
./stalin hello.sc
./hello
```

## 🖥️ Local Development (Advanced)

### Prerequisites
- C compiler (GCC or Clang)
- Make
- Python 3
- X11 dev libraries (optional, for graphics)

### macOS Issues
**Xcode License**: If you see "You have not agreed to the Xcode license", run:
```bash
sudo xcodebuild -license accept
```

### Build Locally
```bash
# Try the development build
./build-stalin-dev.sh

# Or the simple build
./build-simple

# If those fail, use Docker!
```

## 📝 Your First Program

### 1. Create a Scheme file
```scheme
; hello.sc
(display "Hello from Lispy!")
(newline)
```

### 2. Compile it
```bash
./stalin hello.sc
```

### 3. Run it
```bash
./hello
# Output: Hello from Lispy!
```

## 🧪 Run Tests

### Using Docker (Recommended)
```bash
docker-compose run --rm stalin-test
```

### Locally
```bash
cd benchmarks
# Run individual tests
./stalin boyer.sc
./boyer
```

## 🛠️ Common Commands

### Docker Commands
```bash
# Build environment
docker-compose build

# Interactive shell
docker-compose run --rm stalin-dev

# Run tests
docker-compose run --rm stalin-test

# Build Stalin
docker-compose run --rm stalin-build

# Clean up
docker-compose down
docker system prune
```

### Development Commands
```bash
# Build Stalin
./build-modern     # Enhanced build
./build-simple     # Minimal build
./build            # Original build

# Create minimal GC
./create-minimal-gc.sh

# Build Boehm GC
./build-gc-arm64.sh
```

## ❗ Troubleshooting

### Docker Issues

#### "Cannot connect to Docker daemon"
**Solution**: Start Docker Desktop first!

#### "No space left on device"
**Solution**: Clean Docker cache
```bash
docker system prune -a
```

### Build Issues

#### "ld: library 'gc' not found"
**Solution**: Build minimal GC
```bash
./create-minimal-gc.sh
./build-simple
```

#### "Xcode license not accepted"
**Solution**: Accept license or use Docker
```bash
sudo xcodebuild -license accept
# Or just use Docker instead!
```

#### Build hangs/stuck
**Solution**: Use simpler build
```bash
# Kill the stuck process (Ctrl+C)
./build-simple  # Instead of build-modern
```

### Architecture Issues

#### ARM64/M1/M2 Mac warnings
**Status**: Expected - using x86 compatibility mode
**Solution**: Native ARM64 support coming soon!

## 📚 Next Steps

1. **Read the Documentation**
   - [README.md](README.md) - Project overview
   - [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide
   - [LISPY_ROADMAP.md](LISPY_ROADMAP.md) - Future plans

2. **Try Examples**
   ```bash
   cd benchmarks
   ls *.sc  # See available examples
   ```

3. **Join Development**
   - Report issues on GitHub
   - Test on your platform
   - Contribute improvements

## 🆘 Getting Help

1. **Check Documentation**
   - [VALIDATION_RESULTS.md](VALIDATION_RESULTS.md) - Known issues
   - [README.original](README.original) - Historical docs

2. **GitHub Issues**
   - Search existing issues
   - Create new issue with details

3. **Quick Fixes**
   - Use Docker for consistent environment
   - Try `build-simple` if `build-modern` fails
   - Check you have all prerequisites

## 🎯 Quick Success Test

Run this to verify everything works:

```bash
# Using Docker (recommended)
docker run --rm stalin-dev /bin/bash -c "
  echo '(display \"Stalin/Lispy works!\") (newline)' > test.sc &&
  ./stalin test.sc &&
  ./test
"

# Or locally (if Stalin is built)
echo '(display "Stalin/Lispy works!") (newline)' > test.sc
./stalin test.sc
./test
```

If you see "Stalin/Lispy works!" - you're ready to go! 🎉