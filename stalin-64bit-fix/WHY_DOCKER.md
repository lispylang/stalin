# Why We Need Docker - Simple Explanation

**TL;DR:** The old Stalin compiler only works on 32-bit systems. Docker lets us run a 32-bit system on your 64-bit Mac. We use the old compiler there to generate a new 64-bit version.

---

## The Problem We're Solving

### What We Have

1. **stalin.sc** - The Stalin compiler source code (written in Scheme)
   - 32,000 lines
   - This is what we want to compile

2. **stalin.c** - C code generated from stalin.sc back in 2006
   - 692,000 lines
   - Generated on a 32-bit computer
   - Has hardcoded assumptions: `sizeof(void*) == 4`

### What's Wrong

When you try to compile the old stalin.c on your modern 64-bit Mac:

```bash
$ gcc stalin.c -o stalin
```

**Error:** The code has assertions like this:

```c
assert(sizeof(void*) == 4);  // Pointer is 4 bytes
```

But on modern 64-bit systems:
```c
sizeof(void*) == 8  // Pointer is actually 8 bytes!
```

**Result:** Compilation fails. The old stalin.c won't compile on 64-bit systems.

---

## The Chicken-and-Egg Problem

To understand why we need Docker, you need to understand the bootstrap problem:

```
┌─────────────────────────────────────────────┐
│ To get a 64-bit Stalin compiler, we need:  │
│                                             │
│  1. Compile stalin.sc (source code)        │
│     ↓                                       │
│  2. But we need a working Stalin compiler  │
│     ↓                                       │
│  3. Our Stalin compiler is broken          │
│     ↓                                       │
│  4. (stalin.c won't compile on 64-bit)     │
│     ↓                                       │
│  Back to step 1... ∞                        │
└─────────────────────────────────────────────┘
```

**We need a working Stalin to create a working Stalin.**

---

## Why We Can't Just Fix It

### Option 1: Edit stalin.c by Hand ❌

**Problem:**
- 692,000 lines of auto-generated C code
- Thousands of hardcoded values:
  ```c
  offset = 4;  // Pointer offset for 32-bit
  offset = 8;  // Different for 64-bit
  struct_size = field1 + field2 + 4;  // Hardcoded
  padding = (4 - (size % 4)) % 4;     // 32-bit alignment
  ```

**Effort:** Weeks of work, extremely error-prone

### Option 2: Use Chez Scheme Instead ❌

**What we tried:**
- Chez Scheme can compile Scheme code
- Maybe we can use it to compile stalin.sc?

**Problem we hit:**
- Stalin uses `parent` as a variable name (524 times!)
  ```scheme
  (define (parent env) ...)
  (let ((p (parent x))) ...)
  ```
- Chez Scheme reserves `parent` as a keyword
  ```scheme
  (define-record-type foo
    (parent bar)  ; ← This is a reserved keyword
    ...)
  ```

**Effort:** Would need to rename 524 occurrences, test everything - days of work

### Option 3: Get a 32-bit Computer ❌

**What we'd need:**
- Find an old 32-bit computer from 2006
- Install 32-bit Linux
- Copy stalin.c there
- Compile it
- Use it to generate new stalin.c
- Copy back to Mac

**Effort:** Impractical, slow, can't easily share with others

---

## The Docker Solution ✅

### The Key Insight

**The old stalin.c works perfectly fine on 32-bit systems!**

On a 32-bit computer:
```c
assert(sizeof(void*) == 4);  // ✅ TRUE!
```

**Docker lets us create a virtual 32-bit computer on your 64-bit Mac.**

### What Docker Does

Think of Docker as a "computer inside your computer":

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  Your Mac (2025)                          ┃
┃  - 64-bit ARM processor                   ┃
┃  - macOS                                  ┃
┃  - sizeof(void*) == 8                     ┃
┃                                           ┃
┃  ┌─────────────────────────────────────┐ ┃
┃  │ Docker Container                    │ ┃
┃  │ (Simulated 32-bit Linux)           │ ┃
┃  │                                     │ ┃
┃  │ - Pretends to be 32-bit            │ ┃
┃  │ - sizeof(void*) == 4               │ ┃
┃  │ - Old stalin.c compiles here! ✅   │ ┃
┃  └─────────────────────────────────────┘ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### How We Use Docker

**Step 1: Create a 32-bit environment**
```bash
docker run --platform linux/386 debian:bullseye
# Docker creates a virtual 32-bit Linux system
```

**Step 2: Compile the old stalin.c there**
```bash
# Inside Docker (32-bit world):
cd /stalin
gcc stalin.c -o stalin
# ✅ Works! Because sizeof(void*) == 4 in this environment
```

**Step 3: Use the working Stalin to recompile itself for 64-bit**
```bash
# Still in Docker, but tell Stalin to generate 64-bit code:
./stalin -architecture AMD64 stalin.sc
# Creates NEW stalin.c with 64-bit settings
```

**Step 4: Bring the new stalin.c back to your Mac**
```bash
# Copy out of Docker container
cp stalin.c /output/stalin-64bit.c

# On your Mac (64-bit):
gcc stalin-64bit.c -o stalin
# ✅ Works! Because this stalin.c has sizeof(void*) == 8
```

---

## The Complete Picture

```
┌─────────────────────────────────────────────────────────┐
│ DOCKER CONTAINER (32-bit Linux)                         │
│                                                          │
│  ┌──────────────┐                                       │
│  │ stalin.c     │  ← The old 32-bit C code              │
│  │ (from 2006)  │                                       │
│  └──────┬───────┘                                       │
│         │                                                │
│         │ gcc (works because 32-bit environment)        │
│         ↓                                                │
│  ┌──────────────┐                                       │
│  │ stalin       │  ← Working Stalin compiler!           │
│  │ (32-bit exe) │                                       │
│  └──────┬───────┘                                       │
│         │                                                │
│         │ ./stalin -architecture AMD64 stalin.sc        │
│         ↓                                                │
│  ┌──────────────┐                                       │
│  │ stalin.c     │  ← NEW C code with 64-bit settings   │
│  │ (NEW)        │                                       │
│  └──────┬───────┘                                       │
│         │                                                │
│         │ Copy to host Mac                              │
└─────────┼────────────────────────────────────────────────┘
          │
          ↓
┌─────────┴────────────────────────────────────────────────┐
│ YOUR MAC (64-bit)                                        │
│                                                          │
│  ┌──────────────┐                                       │
│  │ stalin.c     │  ← 64-bit compatible version          │
│  │ (NEW)        │                                       │
│  └──────┬───────┘                                       │
│         │                                                │
│         │ gcc (works because 64-bit assumptions)        │
│         ↓                                                │
│  ┌──────────────┐                                       │
│  │ stalin       │  ← Working 64-bit Stalin! 🎉          │
│  │ (64-bit exe) │                                       │
│  └──────────────┘                                       │
└──────────────────────────────────────────────────────────┘
```

---

## Why This Works: Stalin's Architecture System

Stalin was designed to generate code for multiple architectures:

**In stalin.architectures file:**
```scheme
;; 32-bit Intel (what the old stalin.c used)
(define IA32-architecture
  '((pointer-size . 4)         ; 4-byte pointers
    (pointer-alignment . 2)    ; 4-byte alignment
    ...))

;; 64-bit Intel (what we want)
(define AMD64-architecture
  '((pointer-size . 8)         ; 8-byte pointers!
    (pointer-alignment . 3)    ; 8-byte alignment
    ...))
```

**When we run:**
```bash
./stalin -architecture AMD64 stalin.sc
```

**Stalin generates C code using:**
```c
// Uses AMD64 settings:
sizeof(void*) == 8
alignment = 8
offset calculations for 64-bit
```

**This is cross-compilation:**
- Running **on** 32-bit (inside Docker)
- Generating code **for** 64-bit (AMD64 target)

Just like:
```bash
# Compile ON x86 FOR ARM:
gcc -march=armv7 program.c

# We're doing:
# Compile ON 32-bit FOR 64-bit:
./stalin -architecture AMD64 stalin.sc
```

---

## Comparison of Approaches

| Approach | Time | Success | Why |
|----------|------|---------|-----|
| **Edit stalin.c manually** | Weeks | 10% | 692K lines, thousands of values |
| **Port to Chez Scheme** | Days | 30% | `parent` keyword conflict (524 fixes needed) |
| **Find 32-bit computer** | Days | 50% | Hard to find, slow, not reproducible |
| **Docker 32-bit** | 30 min | 90% | ✅ Clean, fast, automated |

---

## What the Automated Script Does

The `docker-build.sh` script automates everything:

```bash
#!/bin/bash

# 1. Check Docker is running
docker info || exit 1

# 2. Start 32-bit container with Stalin source mounted
docker run --platform linux/386 \
  -v /Applications/lispylang/stalin:/stalin \
  debian:bullseye bash -c '

  # 3. Install build tools
  apt-get update && apt-get install -y gcc make libgc-dev

  # 4. Compile old stalin.c (works in 32-bit!)
  cd /stalin
  ./build

  # 5. Use working Stalin to generate 64-bit stalin.c
  ./stalin -architecture AMD64 \
           -Ob -Om -On -Or -Ot \
           stalin.sc

  # 6. Copy result out
  cp stalin.c /stalin/stalin-64bit-fix/stalin-64bit.c
'

# 7. Compile on Mac
cosmocc -o stalin-64bit.com stalin-64bit.c

# 8. Test
./stalin-64bit.com --version
```

**You just run:**
```bash
./docker-build.sh
```

**And it does everything automatically in ~10-15 minutes.**

---

## Common Questions

### Q: Why not just change the assertions in stalin.c?

**A:** The assertions are just the visible errors. The real problem is thousands of calculations:

```c
// stalin.c has THOUSANDS of these kinds of things:
struct {
  int tag;           // 4 bytes
  void* field1;      // 4 bytes on 32-bit, 8 on 64-bit
  void* field2;      // 4 bytes on 32-bit, 8 on 64-bit
};

// Hardcoded offset calculations:
#define FIELD1_OFFSET 4    // Wrong for 64-bit! Should be 8
#define FIELD2_OFFSET 8    // Wrong for 64-bit! Should be 16

// Thousands of places like this throughout 692K lines
```

You'd need to recalculate all of them.

### Q: Can't we just remove the platform check from Docker?

**A:** That's not how it works. Docker `--platform linux/386` actually creates a 32-bit environment. It's not just a flag, it fundamentally changes:
- How pointers work
- How memory is laid out
- What sizeof() returns
- What the compiler generates

### Q: Why does Stalin need to compile itself?

**A:** Stalin is "self-hosting" - it's written in Scheme and compiles Scheme to C. To get a Stalin binary, you:
1. Compile stalin.sc (Scheme source)
2. Get stalin.c (C code)
3. Compile stalin.c (C compilation)
4. Get stalin (binary)

We're stuck at step 2 because we don't have a working Stalin to do step 1.

### Q: How does a 32-bit program generate 64-bit code?

**A:** The Stalin compiler doesn't execute 64-bit code, it **writes** it as text:

```
┌────────────────────────────────────┐
│ Stalin (32-bit binary)             │
│                                    │
│ Reads: stalin.sc (text file)       │
│ Reads: architectures (settings)    │
│ Writes: stalin.c (text file)       │
│                                    │
│ It's just writing text!            │
│ Doesn't matter if it's 32 or 64   │
└────────────────────────────────────┘
```

Like a 32-bit text editor can write "sizeof(void*) = 8" even though that's not true for the editor itself.

---

## Summary

**The Problem:**
- Old stalin.c (32-bit) won't compile on modern 64-bit Macs
- Need a working Stalin to generate new stalin.c
- Don't have a working Stalin (chicken-and-egg)

**Why Docker:**
- Creates a 32-bit environment on your 64-bit Mac
- Old stalin.c compiles there
- Gives us a working Stalin compiler
- Use it to generate new 64-bit stalin.c
- Fast, automated, reliable

**The Alternative:**
- Edit 692K lines of C manually (weeks)
- Port Stalin to Chez Scheme (days, already tried, blocked)
- Find actual 32-bit hardware (impractical)

**Bottom Line:**
Docker is just a tool to run old 32-bit software on your modern Mac, so we can bootstrap ourselves to a 64-bit version.

---

**Next Step:** Run `./docker-build.sh` (takes 10-15 minutes)
