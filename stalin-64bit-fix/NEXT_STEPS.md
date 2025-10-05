# Next Steps - Stalin 64-bit Fix

## Current Status: 85% Complete

We've successfully created a comprehensive Chez Scheme compatibility layer and identified the best path forward.

---

## ✅ What's Been Accomplished

1. **Complete problem analysis** - Stalin has 64-bit support built-in (AMD64 architecture)
2. **Chez compatibility layer** - 370 lines, loads QobiScheme successfully
3. **Identified blocker** - Chez `parent` keyword conflicts with Stalin (524 occurrences)
4. **Alternative path ready** - Docker 32-bit approach with full implementation plan

---

## 🚀 To Continue: Docker 32-bit Approach

### Prerequisites

**Start Docker Desktop:**
```bash
open -a Docker
# Wait ~30 seconds for Docker to fully start
```

### Quick Start (Automated)

```bash
cd /Applications/lispylang/stalin/stalin-64bit-fix
./docker-build.sh
```

This script will:
1. ✅ Check if Docker is running
2. ✅ Start 32-bit Debian container
3. ✅ Install build dependencies
4. ✅ Build Stalin in 32-bit mode
5. ✅ Generate stalin.c with AMD64 (64-bit) architecture
6. ✅ Copy stalin-64bit.c to current directory
7. ✅ Verify 64-bit settings

**Expected time:** 10-15 minutes (first run, includes Docker image download)

### Manual Approach (If Script Fails)

```bash
# 1. Start container
docker run --rm -it --platform linux/386 \
  -v /Applications/lispylang/stalin:/stalin \
  -w /stalin \
  debian:bullseye bash

# 2. Inside container:
apt-get update
apt-get install -y gcc g++ make libgc-dev

# 3. Build Stalin
./build

# 4. Generate 64-bit stalin.c
./stalin -architecture AMD64 \
         -Ob -Om -On -Or -Ot \
         stalin.sc

# 5. Check output
ls -lh stalin.c
grep "pointer" stalin.c | head -5

# 6. Copy to host
cp stalin.c /stalin/stalin-64bit-fix/stalin-64bit.c

# 7. Exit container
exit
```

---

## 📋 After Docker Build Succeeds

### Compile to Cosmopolitan APE

```bash
cd /Applications/lispylang/stalin/stalin-64bit-fix

# Compile stalin-64bit.c to Actually Portable Executable
cosmocc -o stalin-64bit.com stalin-64bit.c

# Test the binary
./stalin-64bit.com --version

# Try compiling a simple Scheme program
echo "(display (+ 1 2))" > test.sc
./stalin-64bit.com test.sc -o test
./test  # Should print 3
```

### Verification Checklist

- [ ] stalin-64bit.c exists and is ~20MB
- [ ] Contains `*pointer-size* = 8` or similar
- [ ] No `assert(sizeof(void*) == 4)` assertions
- [ ] Compiles with cosmocc without errors
- [ ] stalin-64bit.com runs on macOS
- [ ] Can compile and run simple Scheme programs
- [ ] Generated binaries are 64-bit

---

## 🐛 Troubleshooting

### Docker not starting

```bash
# Check if Docker is installed
docker --version

# Start Docker Desktop manually
open -a Docker

# Check status
docker info
```

### "Cannot connect to Docker daemon"

Docker Desktop needs 30-60 seconds to fully start. Wait and try again.

### "platform linux/386 not found"

Your Docker doesn't support 32-bit emulation. Options:
1. Update Docker Desktop to latest version
2. Enable Rosetta in Docker settings (macOS only)
3. Use a Linux machine or VM

### Stalin build fails in container

Check the build log:
```bash
# Inside container
cd /stalin
./build 2>&1 | tee build.log
cat build.log
```

Common issues:
- Missing libgc-dev → Install it
- Compiler errors → Check gcc version
- Permission errors → Check volume mount

### stalin.c not generated

```bash
# Check if Stalin binary exists
ls -lh ./stalin

# Try running with verbose output
./stalin -verbose -architecture AMD64 stalin.sc 2>&1 | tee stalin-gen.log
```

---

## 📊 Expected Outcomes

### Success Metrics

After completing Docker approach:

1. **stalin-64bit.c file**
   - Size: ~20MB
   - Contains: AMD64 architecture code
   - Pointer size: 8 bytes
   - No 32-bit assertions

2. **stalin-64bit.com binary**
   - Runs on macOS ARM64
   - Runs on Linux x86_64
   - Can compile Scheme programs
   - Generates 64-bit C code

3. **Full pipeline working**
   - Scheme → stalin-64bit.com → C code → APE binary
   - Universal binaries that run everywhere
   - 64-bit pointer support throughout

---

## 📚 Documentation

**Read these for context:**
- `SESSION2_STATUS.md` - Detailed session summary
- `docker-approach.md` - Why Docker is the right approach
- `REALISTIC_ASSESSMENT.md` - Original decision analysis
- `CHEZ_PROGRESS.md` - Chez compatibility layer details

**Reference these for implementation:**
- `docker-build.sh` - Automated build script
- `stalin-chez-compat.sc` - Compatibility layer (for reference)

---

## 🎯 Final Goals

1. **Generate stalin-64bit.c** - Stalin source compiled for AMD64
2. **Compile to APE** - Universal binary using Cosmopolitan
3. **Validate** - Test on multiple platforms
4. **Document** - Update all documentation
5. **Commit** - Finalize the project

**Estimated time remaining:** 5-7 hours

---

## 💡 Quick Commands Reference

```bash
# Start Docker
open -a Docker

# Run automated build
cd /Applications/lispylang/stalin/stalin-64bit-fix
./docker-build.sh

# Compile result
cosmocc -o stalin-64bit.com stalin-64bit.c

# Test
./stalin-64bit.com --version

# Verify pointer size
./stalin-64bit.com -architecture
```

---

## ✅ When You're Done

Update `START_HERE.md` with:
- [ ] Mark project as 100% complete
- [ ] Add instructions for using stalin-64bit.com
- [ ] Document the Docker approach as the solution
- [ ] Add examples of compiling Scheme→C→APE

Create final commit:
```bash
git add .
git commit -m "feat: Complete 64-bit Stalin via Docker 32-bit approach"
```

---

*Ready to proceed? Start Docker and run `./docker-build.sh`!* 🚀

