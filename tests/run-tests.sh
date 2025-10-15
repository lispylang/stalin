#!/bin/bash
#
# Master test runner for Stalin 64-bit compiler
# Runs all test suites: smoke tests and integration tests
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

# Function to run a test script
run_test() {
    local test_script=$1
    local test_name=$(basename "$test_script" .sh)

    echo -e "${BLUE}Running: $test_name${NC}"
    if bash "$test_script"; then
        ((TESTS_PASSED++))
    else
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$test_name")
    fi
}

echo "========================================"
echo "Stalin 64-bit Compiler Test Suite"
echo "========================================"
echo ""

# Check that stalin-64bit binary exists
if [ ! -f "$PROJECT_ROOT/stalin-64bit" ]; then
    echo -e "${RED}ERROR: stalin-64bit binary not found${NC}"
    echo "Please ensure the binary is built before running tests"
    exit 1
fi

# Check that helper scripts are available
export PATH="$PROJECT_ROOT:$PATH"
if ! command -v stalin-architecture-name &> /dev/null; then
    echo -e "${YELLOW}WARNING: stalin-architecture-name not in PATH${NC}"
    echo "Tests may fail. Ensure helper scripts are in PATH."
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Smoke Tests (quick validation)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Run smoke tests
for test in "$SCRIPT_DIR"/smoke/test-*.sh; do
    if [ -f "$test" ]; then
        run_test "$test"
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Integration Tests (slower)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Run integration tests
for test in "$SCRIPT_DIR"/integration/test-*.sh; do
    if [ -f "$test" ]; then
        run_test "$test"
    fi
done

echo ""
echo "========================================"
echo "Test Results"
echo "========================================"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}Failed tests:${NC}"
    for test in "${FAILED_TESTS[@]}"; do
        echo -e "${RED}  - $test${NC}"
    done
    echo ""
    exit 1
else
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    exit 0
fi
