#!/bin/bash
# Optimized build script for Stalin Scheme compiler using Cosmopolitan
# Provides various optimization levels and build configurations

set -e  # Exit on error

# Default values
INPUT_FILE=""
OPTIMIZATION="-O2"
MODE="standard"
ARCH="native"
VERBOSE=false
OUTPUT=""
STRIP=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 [OPTIONS] <input.sc>"
    echo ""
    echo "Options:"
    echo "  -o <output>     Output binary name (default: input name without .sc)"
    echo "  -O <level>      Optimization level: 0, 1, 2, 3, s, z, fast (default: 2)"
    echo "  -m <mode>       Build mode: standard, tiny, debug, optlinux (default: standard)"
    echo "  -a <arch>       Architecture: native, x86-64, armv8-a, universal (default: native)"
    echo "  -s              Strip binary for smaller size"
    echo "  -v              Verbose output (enables BUILDLOG)"
    echo "  -h              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 hello.sc                    # Standard build"
    echo "  $0 -O3 -mtiny hello.sc         # Tiny optimized build"
    echo "  $0 -Ofast -s hello.sc          # Maximum performance, stripped"
    echo "  $0 -m debug -v hello.sc        # Debug build with verbose output"
    exit 0
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Parse command line arguments
while getopts "o:O:m:a:svh" opt; do
    case $opt in
        o) OUTPUT="$OPTARG" ;;
        O)
            case $OPTARG in
                0|1|2|3|s|z|fast)
                    OPTIMIZATION="-O$OPTARG" ;;
                *)
                    log_error "Invalid optimization level: $OPTARG" ;;
            esac
            ;;
        m)
            case $OPTARG in
                standard|tiny|debug|optlinux)
                    MODE="$OPTARG" ;;
                *)
                    log_error "Invalid mode: $OPTARG" ;;
            esac
            ;;
        a)
            case $OPTARG in
                native|x86-64|armv8-a|universal)
                    ARCH="$OPTARG" ;;
                *)
                    log_error "Invalid architecture: $OPTARG" ;;
            esac
            ;;
        s) STRIP=true ;;
        v) VERBOSE=true ;;
        h) usage ;;
        \?) log_error "Invalid option: -$OPTARG" ;;
    esac
done

shift $((OPTIND-1))

# Check if input file is provided
if [ $# -eq 0 ]; then
    log_error "No input file specified. Use -h for help."
fi

INPUT_FILE="$1"

# Validate input file
if [ ! -f "$INPUT_FILE" ]; then
    log_error "Input file not found: $INPUT_FILE"
fi

# Set output name if not specified
if [ -z "$OUTPUT" ]; then
    OUTPUT="${INPUT_FILE%.sc}"
fi

# Enable build logging if verbose
if [ "$VERBOSE" = true ]; then
    export BUILDLOG="build-$$.log"
    log_info "Build log will be saved to: $BUILDLOG"
fi

log_info "Building $INPUT_FILE..."
log_info "Configuration: mode=$MODE, optimization=$OPTIMIZATION, arch=$ARCH"

# First, compile Scheme to C using Stalin
log_info "Generating C code from Scheme..."
if [ -f "./stalin" ]; then
    # Use local Stalin binary
    ./stalin -On -c "$INPUT_FILE" || log_error "Stalin compilation failed"
else
    # Use Docker-based compilation
    ./compile "$INPUT_FILE" Cosmopolitan || log_error "Stalin compilation failed"
fi

C_FILE="${INPUT_FILE%.sc}.c"
if [ ! -f "$C_FILE" ]; then
    log_error "C code generation failed - $C_FILE not found"
fi

log_info "C code generated successfully"

# Build compiler flags
COSMOCC_FLAGS=""
ARCH_FLAGS=""

# Add mode-specific flags
case $MODE in
    tiny)
        COSMOCC_FLAGS="$COSMOCC_FLAGS -mtiny"
        log_info "Using tiny mode for minimal binary size"
        ;;
    debug)
        COSMOCC_FLAGS="$COSMOCC_FLAGS -mdbg -g"
        OPTIMIZATION="-O0"
        log_info "Using debug mode with enhanced debugging support"
        ;;
    optlinux)
        COSMOCC_FLAGS="$COSMOCC_FLAGS -moptlinux"
        log_info "Using optimized Linux-only mode"
        ;;
    standard)
        log_info "Using standard mode"
        ;;
esac

# Add architecture-specific flags
case $ARCH in
    native)
        ARCH_FLAGS="-march=native"
        ;;
    x86-64)
        ARCH_FLAGS="-Xx86_64-march=x86-64"
        ;;
    armv8-a)
        ARCH_FLAGS="-Xaarch64-march=armv8-a"
        ;;
    universal)
        # No specific flags for universal
        ;;
esac

# Check if cosmocc is available
if [ ! -f "./cosmocc/bin/cosmocc" ]; then
    log_error "cosmocc not found. Please ensure the Cosmopolitan toolchain is installed."
fi

# Compile C code to binary
log_info "Compiling to native binary..."
COMPILE_CMD="./cosmocc/bin/cosmocc $OPTIMIZATION $COSMOCC_FLAGS $ARCH_FLAGS -o $OUTPUT $C_FILE -I./include -L./include -lm -lgc"

if [ "$VERBOSE" = true ]; then
    log_info "Compile command: $COMPILE_CMD"
fi

if $COMPILE_CMD; then
    log_success "Compilation successful!"
else
    log_error "Compilation failed"
fi

# Strip binary if requested
if [ "$STRIP" = true ]; then
    log_info "Stripping binary..."
    if [ "$MODE" = "tiny" ]; then
        # For tiny mode, extract the raw APE
        ./cosmocc/bin/x86_64-linux-cosmo-objcopy -SO binary "$OUTPUT" "$OUTPUT.com"
        mv "$OUTPUT.com" "$OUTPUT"
        log_info "Extracted raw APE binary for maximum size reduction"
    else
        ./cosmocc/bin/x86_64-linux-cosmo-strip "$OUTPUT"
    fi
fi

# Display binary info
if [ -f "$OUTPUT" ]; then
    SIZE=$(ls -lh "$OUTPUT" | awk '{print $5}')
    log_success "Binary created: $OUTPUT (size: $SIZE)"

    # Show architecture info
    file "$OUTPUT" | head -1

    # Check if it's also a valid ZIP
    if unzip -l "$OUTPUT" >/dev/null 2>&1; then
        log_info "Binary is also a valid ZIP archive (APE format)"
    fi

    # Display generated files
    echo ""
    echo "Generated files:"
    ls -lh "$OUTPUT"* 2>/dev/null | grep -v ".c$"

    # Provide run instructions
    echo ""
    log_success "Run your program with: ./$OUTPUT"

    if [ "$MODE" = "debug" ]; then
        log_info "Debug with: gdb $OUTPUT.com.dbg"
    fi
else
    log_error "Failed to create binary"
fi

# Clean up build log if not verbose
if [ "$VERBOSE" = false ] && [ -n "$BUILDLOG" ]; then
    rm -f "$BUILDLOG"
fi