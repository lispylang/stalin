#!/bin/bash
#
# Test: Compile and run hello.sc (simplest possible Scheme program)
# Expected: Should print "Hello World!" to stdout
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

TEST_NAME="hello"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BENCHMARK_FILE="$PROJECT_ROOT/benchmarks/${TEST_NAME}.sc"
OUTPUT_FILE="/tmp/stalin-test-${TEST_NAME}"
EXPECTED_FILE="$PROJECT_ROOT/tests/fixtures/${TEST_NAME}.expected"
ACTUAL_OUTPUT="/tmp/stalin-test-${TEST_NAME}.output"

# Setup PATH to find stalin-64bit and helper scripts
export PATH="$PROJECT_ROOT:$PATH"

echo "========================================"
echo "Test: ${TEST_NAME}.sc"
echo "========================================"

# Check binary exists
if [ ! -f "$PROJECT_ROOT/stalin-64bit" ]; then
    echo -e "${RED}✗ FAILED: stalin-64bit binary not found${NC}"
    exit 1
fi

# Check benchmark exists
if [ ! -f "$BENCHMARK_FILE" ]; then
    echo -e "${RED}✗ FAILED: Benchmark file not found: $BENCHMARK_FILE${NC}"
    exit 1
fi

# Clean up previous test artifacts
rm -f "$OUTPUT_FILE" "$ACTUAL_OUTPUT"

echo "Compiling ${TEST_NAME}.sc..."
if ! stalin-64bit -d0 -d1 -d5 -d6 -On \
    -copt -O2 -copt -fomit-frame-pointer -copt -Wall \
    "benchmarks/${TEST_NAME}" 2>&1 | grep -v "^$"; then
    echo -e "${RED}✗ FAILED: Compilation failed${NC}"
    exit 1
fi

# Check if compiled binary was created
if [ ! -f "$OUTPUT_FILE" ]; then
    echo -e "${RED}✗ FAILED: Compiled binary not found: $OUTPUT_FILE${NC}"
    exit 1
fi

echo "Running compiled binary..."
if ! "$OUTPUT_FILE" > "$ACTUAL_OUTPUT" 2>&1; then
    echo -e "${RED}✗ FAILED: Binary execution failed${NC}"
    cat "$ACTUAL_OUTPUT"
    exit 1
fi

echo "Comparing output..."
if ! diff -q "$EXPECTED_FILE" "$ACTUAL_OUTPUT" > /dev/null 2>&1; then
    echo -e "${RED}✗ FAILED: Output does not match expected${NC}"
    echo "Expected:"
    cat "$EXPECTED_FILE"
    echo "Actual:"
    cat "$ACTUAL_OUTPUT"
    exit 1
fi

# Cleanup
rm -f "$OUTPUT_FILE" "$ACTUAL_OUTPUT"

echo -e "${GREEN}✓ PASSED: ${TEST_NAME}.sc${NC}"
echo ""
