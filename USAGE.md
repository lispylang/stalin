# Stalin Usage Guide

## Basic Compilation

The simplest way to compile Scheme programs:

```bash
./compile-simple.sh program.sc
./program
```

## Examples

### Hello World
```bash
echo '(display "Hello, World!")' > hello.sc
./compile-simple.sh hello.sc
./hello
```

### Factorial Function
```bash
cat > factorial.sc << 'EOF'
(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (- n 1)))))

(display (factorial 10))
(newline)
EOF

./compile-simple.sh factorial.sc
./factorial
# Output: 3628800
```

### Fibonacci Sequence
```bash
cat > fibonacci.sc << 'EOF'
(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(display (fib 30))
(newline)
EOF

./compile-simple.sh fibonacci.sc
time ./fibonacci  # See Stalin's optimization in action!
```

## Benchmarks

The `benchmarks/` directory contains performance test programs:

```bash
# Classic Lisp benchmarks
./compile-simple.sh benchmarks/boyer.sc
time ./boyer

./compile-simple.sh benchmarks/quicksort.sc
time ./quicksort

./compile-simple.sh benchmarks/matrix.sc
time ./matrix
```

## Advanced Usage

### Docker Development Environment

For interactive development or debugging:

```bash
# Build environment (one-time)
./docker-build.sh

# Interactive session
docker run -it --rm -v $(pwd):/stalin stalin-dev /bin/bash

# Inside container:
./build-simple    # Build Stalin
./stalin -help    # See options
```

### Local Building

Build Stalin locally (expect warnings on ARM64):

```bash
# Simple build (recommended)
./build-simple

# Full build with Boehm GC
./build-modern
```

Note: The locally built `./stalin` binary may not work properly on ARM64 due to struct layout differences. Use `./compile-simple.sh` for reliable compilation.

## Scheme Language Support

Stalin supports most R4RS Scheme features:

### Supported
- Numbers: integers, rationals, reals, complex
- Lists and vectors
- Functions and closures
- Macros
- I/O operations
- String operations

### Examples

```scheme
;; Numbers
(+ 1 2 3)                    ; => 6
(* 3.14159 2.0)              ; => 6.28318
(exact->inexact 22/7)        ; => 3.142857142857143

;; Lists
(list 1 2 3)                 ; => (1 2 3)
(append '(a b) '(c d))       ; => (a b c d)
(map (lambda (x) (* x x)) '(1 2 3 4))  ; => (1 4 9 16)

;; Strings
(string-append "Hello" " " "World")  ; => "Hello World"
(string-length "Stalin")             ; => 6

;; Control flow
(cond ((> 3 2) 'yes)
      (else 'no))            ; => yes

;; File I/O
(with-output-to-file "output.txt"
  (lambda () (display "Hello, file!")))
```

### Not Supported
- Dynamic code loading (`eval`, `load`)
- Interactive REPL features
- Some newer Scheme standards (R5RS+)
- Debugging information in binaries

## Performance Tips

1. **Use specific types** when possible - Stalin's optimizer works best with type information
2. **Avoid `eval`** - Stalin is a whole-program compiler
3. **Profile with `time`** - Stalin-compiled programs are typically very fast
4. **Use benchmarks** - Compare performance with the included benchmark suite

## Troubleshooting

### Common Issues

**Docker not running:**
```bash
# Start Docker Desktop first, then:
docker --version  # Should show version
```

**Compilation fails:**
```bash
# Check syntax in a simple Scheme interpreter first
# Make sure your .sc file contains valid Scheme
```

**Binary doesn't run:**
```bash
# Check if compilation actually succeeded:
ls -la your-program  # Should exist and be executable
./your-program       # Should run
```

**Performance issues:**
```bash
# Stalin is an optimizing compiler - use time to measure:
time ./your-program

# Compare with other Scheme implementations for reference
```

### Getting Help

1. Check the [benchmarks/](benchmarks/) directory for working examples
2. See [README.original](README.original) for historical Stalin documentation
3. Review [LISPY_ROADMAP.md](LISPY_ROADMAP.md) for future development plans

## File Organization

- `*.sc` - Scheme source files
- `compile-simple.sh` - Main compilation script
- `benchmarks/` - Performance test suite
- `include/` - Runtime libraries
- `stalin-*.c` - Generated C code for different architectures

---

Happy Scheme programming with Stalin! 🚀