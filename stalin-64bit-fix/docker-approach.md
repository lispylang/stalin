# Docker 32-bit Approach for Stalin 64-bit Fix

## Problem Encountered

Chez Scheme has fundamental incompatibility with Stalin:
- `parent` is a reserved keyword in Chez (used in record definitions)
- Stalin uses `parent` as a regular identifier 524 times
- Would require massive modifications to stalin.sc

## Alternative: Docker 32-bit Environment

### Strategy
Run Stalin in a true 32-bit Linux environment where it was designed to work,
but configure it to generate C code for AMD64 (64-bit) architecture.

### Steps

1. **Create 32-bit Debian container**
   ```bash
   docker run --platform linux/386 -v $(pwd):/work -w /work -it debian:latest bash
   ```

2. **Inside container: Install dependencies**
   ```bash
   apt-get update
   apt-get install -y gcc make libgc-dev wget
   ```

3. **Build Stalin from source in 32-bit mode**
   ```bash
   cd /work/stalin-64bit-fix
   ../build
   ```

4. **Modify stalin to force AMD64 architecture**
   Edit the generated `stalin` binary wrapper script to force AMD64:
   ```bash
   export ARCHITECTURE=AMD64
   ./stalin -architecture AMD64 -copt -DAMD64 stalin.sc
   ```

5. **Generate stalin.c with 64-bit settings**
   This will produce stalin.c with AMD64/64-bit configuration

6. **Copy stalin.c to host**
   The generated stalin.c can then be compiled on the host macOS system

### Advantages
- Stalin runs in its native environment (32-bit)
- No source code modifications needed
- Cross-compilation from 32-bit to 64-bit is supported
- Stalin's architecture system handles the rest

### Next Steps
Let me try this approach if you want to continue...
