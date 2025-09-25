#!/bin/bash
# Enhanced Stalin compilation with container reuse and better performance

set -e

CONTAINER_NAME="stalin-compiler"
CONTAINER_IMAGE="stalin-x86_64"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}❌ Error:${NC} $1" >&2
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

usage() {
    cat << EOF
Usage: $0 [OPTIONS] <file.sc> [file2.sc ...]

Enhanced Stalin Scheme compiler with container reuse and batch processing.

OPTIONS:
    -h, --help          Show this help message
    -c, --clean         Clean up containers before starting
    -k, --keep          Keep container running after compilation
    -v, --verbose       Verbose output
    --no-optimize       Skip native compilation optimizations

EXAMPLES:
    $0 hello.sc                    # Compile single file
    $0 *.sc                        # Compile all .sc files
    $0 -v hello.sc factorial.sc    # Compile multiple files with verbose output
    $0 -c hello.sc                 # Clean containers first
EOF
}

cleanup_containers() {
    log "Cleaning up existing containers..."
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
    docker container prune -f 2>/dev/null || true
}

ensure_container() {
    if ! docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        log "Starting Stalin compiler container..."
        docker run --platform linux/amd64 -d --name "$CONTAINER_NAME" "$CONTAINER_IMAGE" sleep 3600 > /dev/null

        # Warm up container with setup
        docker exec "$CONTAINER_NAME" bash -c "
            cp include/stalin.architectures . 2>/dev/null || true
            cp include/*.sc . 2>/dev/null || true
            PATH=.:\$PATH
        " 2>/dev/null || true

        success "Container ready for compilation"
    fi
}

compile_scheme_file() {
    local input_file="$1"
    local base_name=$(basename "$input_file" .sc)
    local file_name=$(basename "$input_file")

    if [[ ! -f "$input_file" ]]; then
        error "File not found: $input_file"
        return 1
    fi

    log "🔧 Compiling $input_file..."

    # Copy file to container
    docker cp "$input_file" "${CONTAINER_NAME}:/stalin/" || {
        error "Failed to copy $input_file to container"
        return 1
    }

    # Generate C code with timeout
    local compile_start=$(date +%s)
    if docker exec "$CONTAINER_NAME" timeout 60 bash -c "
        PATH=.:\$PATH
        ./stalin -On -c -architecture AMD64 $file_name 2>/dev/null
    "; then
        local compile_end=$(date +%s)
        local compile_time=$((compile_end - compile_start))

        # Extract generated C code
        if docker cp "${CONTAINER_NAME}:/stalin/${base_name}.c" ./ 2>/dev/null; then
            local c_size=$(wc -l < "${base_name}.c" 2>/dev/null || echo "unknown")
            log "Generated ${base_name}.c (${c_size} lines) in ${compile_time}s"

            # Compile natively
            local native_start=$(date +%s)
            local gcc_flags="-O2"
            [[ "$NO_OPTIMIZE" == "1" ]] && gcc_flags="-O0"

            if gcc -o "$base_name" -I./include $gcc_flags "${base_name}.c" -L./include -lm -lgc 2>/dev/null; then
                local native_end=$(date +%s)
                local native_time=$((native_end - native_start))
                local binary_size=$(ls -lh "$base_name" | awk '{print $5}')

                success "Built $base_name (${binary_size}) in ${native_time}s"
                [[ "$VERBOSE" == "1" ]] && log "Total time: $((compile_time + native_time))s"
                return 0
            else
                error "Native compilation failed for $base_name"
                return 1
            fi
        else
            error "Failed to extract generated C code for $base_name"
            return 1
        fi
    else
        error "Stalin compilation failed for $input_file (timeout or error)"
        return 1
    fi
}

# Parse arguments
CLEAN=0
KEEP=0
VERBOSE=0
NO_OPTIMIZE=0
FILES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -c|--clean)
            CLEAN=1
            shift
            ;;
        -k|--keep)
            KEEP=1
            shift
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        --no-optimize)
            NO_OPTIMIZE=1
            shift
            ;;
        -*)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            FILES+=("$1")
            shift
            ;;
    esac
done

# Validate arguments
if [[ ${#FILES[@]} -eq 0 ]]; then
    error "No input files specified"
    usage
    exit 1
fi

# Check Docker is running
if ! docker info >/dev/null 2>&1; then
    error "Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check image exists
if ! docker image inspect "$CONTAINER_IMAGE" >/dev/null 2>&1; then
    error "Docker image '$CONTAINER_IMAGE' not found. Run ./docker-build.sh first."
    exit 1
fi

# Main execution
trap 'if [[ "$KEEP" != "1" ]]; then docker rm -f "$CONTAINER_NAME" 2>/dev/null || true; fi' EXIT

[[ "$CLEAN" == "1" ]] && cleanup_containers

log "Stalin Fast Compiler v2.0"
log "Processing ${#FILES[@]} file(s)..."

ensure_container

# Compile all files
success_count=0
fail_count=0

for file in "${FILES[@]}"; do
    if compile_scheme_file "$file"; then
        ((success_count++))
    else
        ((fail_count++))
    fi
done

# Summary
echo
if [[ $success_count -gt 0 ]]; then
    success "Successfully compiled $success_count file(s)"
fi

if [[ $fail_count -gt 0 ]]; then
    error "Failed to compile $fail_count file(s)"
    exit 1
else
    success "All files compiled successfully!"
fi

[[ "$KEEP" != "1" ]] && log "Cleaning up container..."