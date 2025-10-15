# Stalin 64-bit Compiler Tests

This directory contains the test suite for validating the Stalin 64-bit compiler.

## Test Structure

```
tests/
├── smoke/          # Quick sanity tests (< 1 minute)
│   ├── test-hello.sh     # Hello World (simplest program)
│   └── test-tak.sh       # TAK benchmark (recursive functions)
├── integration/    # Real-world compilation tests
│   └── test-div-iter.sh  # DIV benchmark (iterative list processing)
├── fixtures/       # Expected output files
│   ├── hello.expected
│   ├── tak.expected
│   └── div-iter.expected
└── run-tests.sh    # Master test runner

```

## Running Tests

### Run all tests:
```bash
./tests/run-tests.sh
```

### Run individual test suites:
```bash
# Smoke tests only (fast)
bash tests/smoke/test-hello.sh
bash tests/smoke/test-tak.sh

# Integration tests
bash tests/integration/test-div-iter.sh
```

## What the Tests Validate

1. **Compilation**: Stalin can compile Scheme programs to C and then to native binaries
2. **Execution**: Compiled binaries run correctly on 64-bit systems
3. **Output correctness**: Programs produce expected output
4. **Architecture support**: Works on both ARM64 (macOS) and AMD64 (Linux)

## Test Details

### Smoke Tests

**test-hello.sh**: Compiles and runs `hello.sc`
- Tests: Basic I/O, simplest possible program
- Expected: Prints "Hello World!"
- Runtime: ~10-30 seconds

**test-tak.sh**: Compiles and runs `tak.sc` (TAK benchmark)
- Tests: Recursive function calls, arithmetic
- Expected: Prints "7" 1000 times
- Runtime: ~30-60 seconds

### Integration Tests

**test-div-iter.sh**: Compiles and runs `div-iter.sc`
- Tests: Iterative list processing, memory allocation
- Expected: Completes without output
- Runtime: ~30-60 seconds

## CI/CD Integration

These tests run automatically on GitHub Actions for:
- Every push to master/main
- Every pull request

The workflow tests on:
- **Ubuntu (AMD64)**: Linux x86-64 platform
- **macOS (ARM64)**: Apple Silicon platform

## Adding New Tests

To add a new test:

1. Create a Scheme program in `benchmarks/` (or use existing)
2. Run it manually to capture expected output
3. Save expected output to `tests/fixtures/yourtest.expected`
4. Create test script in `tests/smoke/` or `tests/integration/`:

```bash
#!/bin/bash
set -e
TEST_NAME="yourtest"
# ... (copy structure from existing tests)
```

5. Make it executable: `chmod +x tests/smoke/test-yourtest.sh`
6. Run `./tests/run-tests.sh` to verify

## Troubleshooting

**"Cannot find: stalin-architecture-name"**
- Ensure helper scripts are in PATH: `export PATH="$PWD:$PATH"`
- Check: `./stalin-architecture-name` should output "ARM64" or "AMD64"

**Compilation fails**
- Ensure Boehm GC is installed: `brew install bdw-gc` (macOS) or `apt-get install libgc-dev` (Linux)
- Check stalin-64bit exists and is 64-bit: `file ./stalin-64bit`

**Output doesn't match**
- Regenerate expected output: Run program manually and save output
- Check for platform-specific differences (newlines, etc.)
