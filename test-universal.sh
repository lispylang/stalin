#!/bin/bash

# Universal Binary Testing Script
# Tests the Stalin + Cosmopolitan universal binary compilation pipeline

set -e

echo "Stalin + Cosmopolitan Universal Binary Test Suite"
echo "================================================="

# Test 1: Basic Hello World
echo "Test 1: Basic Hello World"
if [ ! -f test-hello.sc ]; then
    cat > test-hello.sc << 'EOF'
(define (main)
  (display "Hello from Stalin + Cosmopolitan universal binary!")
  (newline)
  (display "This binary should run on any operating system.")
  (newline))

(main)
EOF
fi

echo "  Compiling test-hello.sc..."
if ./compile-universal test-hello.sc test-hello-universal; then
    echo "  ✓ Compilation successful"

    echo "  Testing execution..."
    if ./test-hello-universal; then
        echo "  ✓ Execution successful"
    else
        echo "  ✗ Execution failed"
    fi
else
    echo "  ✗ Compilation failed"
fi

# Test 2: Mathematical Operations
echo ""
echo "Test 2: Mathematical Operations"
cat > test-math.sc << 'EOF'
(define (factorial n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

(define (main)
  (display "Testing mathematical operations:")
  (newline)
  (display "5! = ")
  (display (factorial 5))
  (newline)
  (display "10! = ")
  (display (factorial 10))
  (newline))

(main)
EOF

echo "  Compiling test-math.sc..."
if ./compile-universal test-math.sc test-math-universal; then
    echo "  ✓ Compilation successful"

    echo "  Testing execution..."
    if ./test-math-universal; then
        echo "  ✓ Execution successful"
    else
        echo "  ✗ Execution failed"
    fi
else
    echo "  ✗ Compilation failed"
fi

# Test 3: String Operations
echo ""
echo "Test 3: String Operations"
cat > test-strings.sc << 'EOF'
(define (string-reverse str)
  (list->string (reverse (string->list str))))

(define (main)
  (let ((test-str "Cosmopolitan"))
    (display "Original string: ")
    (display test-str)
    (newline)
    (display "Reversed string: ")
    (display (string-reverse test-str))
    (newline)
    (display "String length: ")
    (display (string-length test-str))
    (newline)))

(main)
EOF

echo "  Compiling test-strings.sc..."
if ./compile-universal test-strings.sc test-strings-universal; then
    echo "  ✓ Compilation successful"

    echo "  Testing execution..."
    if ./test-strings-universal; then
        echo "  ✓ Execution successful"
    else
        echo "  ✗ Execution failed"
    fi
else
    echo "  ✗ Compilation failed"
fi

echo ""
echo "Test Summary"
echo "============"
echo "Generated universal binaries:"
ls -lh *-universal 2>/dev/null || echo "No universal binaries found"

echo ""
echo "Binary types:"
for binary in *-universal; do
    if [ -f "$binary" ]; then
        echo "  $binary: $(file "$binary")"
    fi
done

echo ""
echo "All tests completed!"