# Stalin/Lispy Usage Guide

## 🚀 Quick Start

### **ARM64/Apple Silicon Users** (Recommended)
```bash
# Compile any Scheme program
./compile-simple.sh hello.sc
./hello

# Try more examples
./compile-simple.sh benchmarks/factorial.sc
./factorial
```

### **Intel/x86_64 Users**
```bash
# Direct compilation
./stalin -On hello.sc
./hello

# Or use Docker for consistency
./compile-simple.sh hello.sc
./hello
```

## 📋 Compilation Workflow

### **The `compile-simple.sh` Script**
This is the recommended way to compile Scheme programs on all platforms:

```bash
./compile-simple.sh <program.sc>
```

**What it does:**
1. **Creates Docker container** with x86_64 Stalin
2. **Copies your .sc file** into the container
3. **Generates C code** using Stalin with AMD64 architecture
4. **Extracts the C code** back to your system
5. **Compiles natively** using your system's GCC
6. **Creates optimized binary** ready to run

### **Manual Compilation** (Advanced)
```bash
# 1. Generate C code using Docker
CONTAINER_ID=$(docker run --platform linux/amd64 -d stalin-x86_64 sleep 300)
docker cp hello.sc ${CONTAINER_ID}:/stalin/
docker exec ${CONTAINER_ID} bash -c "
    cp include/stalin.architectures .
    PATH=.:\$PATH
    ./stalin -On -c -architecture AMD64 hello.sc
"
docker cp ${CONTAINER_ID}:/stalin/hello.c ./hello.c
docker rm -f ${CONTAINER_ID}

# 2. Compile natively
gcc -o hello -I./include -O2 hello.c -L./include -lm -lgc
./hello
```

## 🎯 Examples

### **Hello World**
```scheme
;; hello.sc
(display "Hello, World!")
(newline)
```
```bash
./compile-simple.sh hello.sc
./hello  # Output: Hello, World!
```

### **Factorial**
```scheme
;; factorial.sc
(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (- n 1)))))

(display "10! = ")
(display (factorial 10))
(newline)
```
```bash
./compile-simple.sh factorial.sc
./factorial  # Output: 10! = 3628800
```

### **Fibonacci**
```scheme
;; fibonacci.sc
(define (fibonacci n)
  (if (<= n 1)
      n
      (+ (fibonacci (- n 1))
         (fibonacci (- n 2)))))

(display "fib(30) = ")
(display (fibonacci 30))
(newline)
```
```bash
./compile-simple.sh fibonacci.sc
time ./fibonacci  # See Stalin's optimization in action!
```

## 🏁 Benchmarks

### **Performance Testing**
```bash
# Boyer theorem prover
./compile-simple.sh benchmarks/boyer.sc
time ./boyer

# Quick sort
./compile-simple.sh benchmarks/quicksort.sc
time ./quicksort

# Conway's Game of Life
./compile-simple.sh benchmarks/life.sc
./life

# Ray tracer
./compile-simple.sh benchmarks/ray.sc
./ray > output.ppm
```

### **Comparing with Interpreted Scheme**
```bash
# Compile with Stalin
./compile-simple.sh benchmarks/boyer.sc
time ./boyer

# Compare with Chez Scheme (if installed)
time chez --script benchmarks/boyer.sc

# Stalin is typically 10-100x faster!
```

## 🛠️ Troubleshooting

### **Docker Issues**
```bash
# Make sure Docker is running
docker ps

# Build the x86_64 image if needed
docker build --platform linux/amd64 -t stalin-x86_64 -f Dockerfile.x86_64 .
```

### **Compilation Errors**
```bash
# Check if C code was generated
ls -la *.c

# Manual compilation with verbose output
gcc -v -o program -I./include -O2 program.c -L./include -lm -lgc
```

### **Runtime Issues**
```bash
# Check binary architecture
file ./program

# Run with debugging
gdb ./program
```

## 📝 Stalin Language Features

### **Supported Scheme**
- R4RS Scheme (mostly)
- Numeric tower (fixnums, flonums)
- First-class procedures and closures
- Tail recursion optimization
- Aggressive whole-program optimization

### **Key Optimizations**
- **Type inference**: Eliminates boxing/unboxing
- **Representation selection**: Uses native C types
- **Dead code elimination**: Removes unused code
- **Closure optimization**: Efficient closure compilation
- **Lifetime analysis**: Reduces GC pressure

### **Limitations**
- No dynamic loading
- No `eval` at runtime
- Compilation can be slow for large programs
- Limited debugging info in optimized code

## 🎨 Advanced Usage

### **Optimization Levels**
```bash
# Maximum optimization (default with -On)
./compile-simple.sh program.sc

# The script always uses -On for best performance
```

### **Multiple Files**
```bash
# Create main program
echo '(load "utils.sc") (main)' > main.sc

# Compile (load statements are resolved at compile time)
./compile-simple.sh main.sc
./main
```

### **Custom Build Flags**
```bash
# Edit compile-simple.sh to add custom GCC flags
# For example, add -march=native for CPU-specific optimizations
```

## 🚀 What's Next?

1. **Try the benchmarks** - See Stalin's incredible performance
2. **Write your own programs** - Scheme with C-like speed
3. **Contribute** - Help improve the ARM64 support
4. **Explore optimization** - Profile your compiled programs

Stalin is one of the fastest Scheme compilers ever created. Enjoy the speed! 🏎️