#!/bin/bash
# Stalin Architecture Testing Script
# ================================
#
# This script systematically tests Stalin's ability to generate C code
# for all supported architectures defined in stalin.architectures
#
# Author: Claude Code Development Team
# Date: 2024

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONTAINER_IMAGE="stalin-x86_64"
TEST_FILE="arch-test.sc"
RESULTS_FILE="architecture-test-results.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# All architectures from stalin.architectures
ARCHITECTURES=(
    "IA32"
    "IA32-align-double"
    "SPARC"
    "SPARCv9"
    "SPARC64"
    "MIPS"
    "Alpha"
    "ARM"
    "M68K"
    "PowerPC"
    "S390"
    "PowerPC64"
    "AMD64"
)

# Test program - simple hello world
TEST_PROGRAM='(display "Hello from Stalin architecture test!")'

echo -e "${BLUE}Stalin Architecture Compilation Test${NC}"
echo -e "${BLUE}===================================${NC}"
echo "Testing ${#ARCHITECTURES[@]} architectures..."
echo "Timestamp: $TIMESTAMP"
echo ""

# Check if Docker image exists
if ! docker images | grep -q "$CONTAINER_IMAGE"; then
    echo -e "${RED}Error: Docker image '$CONTAINER_IMAGE' not found${NC}"
    echo "Please run './docker-build.sh' first to build the Stalin Docker environment"
    exit 1
fi

# Create test program
echo "$TEST_PROGRAM" > "$TEST_FILE"
echo "Created test program: $TEST_FILE"
echo ""

# Initialize results
echo "Stalin Architecture Test Results" > "$RESULTS_FILE"
echo "===============================" >> "$RESULTS_FILE"
echo "Timestamp: $TIMESTAMP" >> "$RESULTS_FILE"
echo "Test program: $TEST_PROGRAM" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Results counters
PASSED=0
FAILED=0
WARNINGS=0

echo -e "${BLUE}Testing architectures:${NC}"
echo ""

for arch in "${ARCHITECTURES[@]}"; do
    echo -ne "Testing ${YELLOW}$arch${NC}... "

    # Create container
    CONTAINER_ID=$(docker run --platform linux/amd64 -d "$CONTAINER_IMAGE" sleep 180 2>/dev/null)

    if [ -z "$CONTAINER_ID" ]; then
        echo -e "${RED}FAILED${NC} (container creation)"
        echo "$arch: FAILED - Could not create Docker container" >> "$RESULTS_FILE"
        ((FAILED++))
        continue
    fi

    # Copy test file to container
    if ! docker cp "$TEST_FILE" "${CONTAINER_ID}:/stalin/" 2>/dev/null; then
        echo -e "${RED}FAILED${NC} (file copy)"
        echo "$arch: FAILED - Could not copy test file to container" >> "$RESULTS_FILE"
        docker rm -f "$CONTAINER_ID" >/dev/null 2>&1
        ((FAILED++))
        continue
    fi

    # Copy architecture definitions
    docker exec "$CONTAINER_ID" bash -c "cp include/stalin.architectures . 2>/dev/null || true"

    # Test compilation
    OUTPUT_FILE="arch-test.c"
    COMPILE_OUTPUT=$(docker exec "$CONTAINER_ID" bash -c "
        cd /stalin
        PATH=.:\$PATH
        ./stalin -On -c -architecture $arch $TEST_FILE 2>&1
    " 2>&1)

    COMPILE_STATUS=$?

    # Check if C file was generated
    C_FILE_EXISTS=$(docker exec "$CONTAINER_ID" bash -c "[ -f /stalin/$OUTPUT_FILE ] && echo 'yes' || echo 'no'" 2>/dev/null || echo 'no')

    # Extract C file for analysis if it exists
    if [ "$C_FILE_EXISTS" = "yes" ]; then
        docker cp "${CONTAINER_ID}:/stalin/$OUTPUT_FILE" "./${arch}-test.c" 2>/dev/null || true
    fi

    # Clean up container
    docker rm -f "$CONTAINER_ID" >/dev/null 2>&1

    # Analyze results
    if [ $COMPILE_STATUS -eq 0 ] && [ "$C_FILE_EXISTS" = "yes" ]; then
        # Check if generated C file looks valid
        if [ -f "${arch}-test.c" ]; then
            # Basic validation: check for main function and basic C structure
            if grep -q "int main" "${arch}-test.c" && grep -q "#include" "${arch}-test.c"; then
                echo -e "${GREEN}PASSED${NC}"
                echo "$arch: PASSED - Generated valid C code" >> "$RESULTS_FILE"
                ((PASSED++))
            else
                echo -e "${YELLOW}WARNING${NC} (invalid C)"
                echo "$arch: WARNING - Generated C code appears invalid" >> "$RESULTS_FILE"
                ((WARNINGS++))
            fi
        else
            echo -e "${YELLOW}WARNING${NC} (no C file)"
            echo "$arch: WARNING - Compilation succeeded but no C file extracted" >> "$RESULTS_FILE"
            ((WARNINGS++))
        fi
    else
        echo -e "${RED}FAILED${NC}"
        echo "$arch: FAILED - Compilation failed or no C file generated" >> "$RESULTS_FILE"
        if [ -n "$COMPILE_OUTPUT" ]; then
            echo "  Error output: $COMPILE_OUTPUT" >> "$RESULTS_FILE"
        fi
        ((FAILED++))
    fi
done

echo ""
echo -e "${BLUE}Test Summary:${NC}"
echo "============="
echo -e "${GREEN}Passed:   $PASSED${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "${RED}Failed:   $FAILED${NC}"
echo -e "Total:    ${#ARCHITECTURES[@]}"

# Add summary to results file
echo "" >> "$RESULTS_FILE"
echo "SUMMARY:" >> "$RESULTS_FILE"
echo "========" >> "$RESULTS_FILE"
echo "Passed:   $PASSED" >> "$RESULTS_FILE"
echo "Warnings: $WARNINGS" >> "$RESULTS_FILE"
echo "Failed:   $FAILED" >> "$RESULTS_FILE"
echo "Total:    ${#ARCHITECTURES[@]}" >> "$RESULTS_FILE"

echo ""
echo "Detailed results written to: $RESULTS_FILE"
echo "Generated C files: ./*-test.c"

# Update ARCHITECTURE_SUPPORT.md with results
if [ -f "ARCHITECTURE_SUPPORT.md" ]; then
    echo ""
    echo "Updating ARCHITECTURE_SUPPORT.md with test results..."

    # Create a temporary file with updated content
    sed -i.bak "s/\*Last updated: \[Date will be filled by testing script\]\*/Last updated: $TIMESTAMP/" ARCHITECTURE_SUPPORT.md
    sed -i.bak "s/\*Test results: \[Results will be updated by testing script\]\*/Test results: $PASSED passed, $WARNINGS warnings, $FAILED failed/" ARCHITECTURE_SUPPORT.md

    # Update individual architecture status based on results
    while IFS= read -r line; do
        if [[ $line == *": PASSED"* ]]; then
            arch=$(echo "$line" | cut -d: -f1)
            sed -i.bak "s/| \*\*$arch\*\* | .* | 🔧 Pending |/| **$arch** | ... | ✅ Working |/" ARCHITECTURE_SUPPORT.md
        elif [[ $line == *": WARNING"* ]]; then
            arch=$(echo "$line" | cut -d: -f1)
            sed -i.bak "s/| \*\*$arch\*\* | .* | 🔧 Pending |/| **$arch** | ... | ⚠️ Issues |/" ARCHITECTURE_SUPPORT.md
        elif [[ $line == *": FAILED"* ]]; then
            arch=$(echo "$line" | cut -d: -f1)
            sed -i.bak "s/| \*\*$arch\*\* | .* | 🔧 Pending |/| **$arch** | ... | ❌ Broken |/" ARCHITECTURE_SUPPORT.md
        fi
    done < "$RESULTS_FILE"

    rm -f ARCHITECTURE_SUPPORT.md.bak
    echo "ARCHITECTURE_SUPPORT.md updated with test results"
fi

# Clean up
rm -f "$TEST_FILE"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All architectures tested successfully!${NC}"
    exit 0
else
    echo -e "\n${YELLOW}Some architectures failed testing. See results for details.${NC}"
    exit 1
fi