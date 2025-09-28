#!/bin/bash
# WebAssembly compilation script for Stalin Scheme
# Requires Emscripten SDK (emsdk)

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./compile-wasm.sh <file.sc> [options]"
    echo ""
    echo "Options:"
    echo "  -O <level>      Optimization level (0-3, s, z)"
    echo "  -o <output>     Output filename (default: based on input)"
    echo "  --debug         Enable debug mode"
    echo "  --standalone    Create standalone HTML file"
    echo ""
    echo "Requires Emscripten SDK to be installed and activated:"
    echo "  git clone https://github.com/emscripten-core/emsdk.git"
    echo "  cd emsdk && ./emsdk install latest && ./emsdk activate latest"
    echo "  source ./emsdk_env.sh"
    exit 1
fi

INPUT_FILE=$1
shift

# Default values
OPTIMIZATION="-O2"
OUTPUT=""
DEBUG=false
STANDALONE=false

# Parse remaining arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -O)
            OPTIMIZATION="-O$2"
            shift 2
            ;;
        -o)
            OUTPUT="$2"
            shift 2
            ;;
        --debug)
            DEBUG=true
            OPTIMIZATION="-O0"
            shift
            ;;
        --standalone)
            STANDALONE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

BASE_NAME=$(basename "$INPUT_FILE" .sc)

if [ -z "$OUTPUT" ]; then
    if [ "$STANDALONE" = true ]; then
        OUTPUT="$BASE_NAME.html"
    else
        OUTPUT="$BASE_NAME.js"
    fi
fi

# Check if emcc is available
if ! command -v emcc &> /dev/null; then
    echo "❌ Emscripten not found. Please install and activate the Emscripten SDK:"
    echo "   git clone https://github.com/emscripten-core/emsdk.git"
    echo "   cd emsdk && ./emsdk install latest && ./emsdk activate latest"
    echo "   source ./emsdk_env.sh"
    exit 1
fi

echo "🌐 Compiling $INPUT_FILE to WebAssembly..."

# Generate C code using Stalin
echo "📝 Generating C code from Scheme..."
if ! ./compile "$INPUT_FILE" WASM32; then
    echo "❌ Failed to generate C code"
    exit 1
fi

C_FILE="${BASE_NAME}.c"
if [ ! -f "$C_FILE" ]; then
    echo "❌ C file not found: $C_FILE"
    exit 1
fi

echo "🔧 Compiling C to WebAssembly..."

# Emscripten compilation flags
EMCC_FLAGS=(
    "$OPTIMIZATION"
    "-s" "WASM=1"
    "-s" "EXPORTED_FUNCTIONS=['_main']"
    "-s" "EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
    "-s" "ALLOW_MEMORY_GROWTH=1"
    "-s" "TOTAL_STACK=16MB"
    "-s" "INITIAL_MEMORY=64MB"
    "-s" "EXIT_RUNTIME=1"
)

# Add debug flags if requested
if [ "$DEBUG" = true ]; then
    EMCC_FLAGS+=("-g" "-s" "ASSERTIONS=1" "-s" "SAFE_HEAP=1")
fi

# Add standalone HTML generation if requested
if [ "$STANDALONE" = true ]; then
    EMCC_FLAGS+=("--shell-file" "${EMSCRIPTEN}/src/shell.html")
fi

# Compile with emcc
if emcc "${EMCC_FLAGS[@]}" -o "$OUTPUT" "$C_FILE"; then
    echo "✅ WebAssembly compilation successful!"
    echo "   Output: $OUTPUT"

    # List generated files
    echo ""
    echo "Generated files:"
    if [ "$STANDALONE" = true ]; then
        ls -lh "${BASE_NAME}".* | grep -E "\.(html|js|wasm)$"
    else
        ls -lh "${BASE_NAME}".* | grep -E "\.(js|wasm)$"
    fi

    echo ""
    if [ "$STANDALONE" = true ]; then
        echo "🌐 Open $OUTPUT in a web browser to run"
        echo "   Or serve with: python3 -m http.server 8000"
    else
        echo "🌐 Run in Node.js with: node $OUTPUT"
        echo "   Or include in HTML: <script src=\"$OUTPUT\"></script>"
    fi

    # Show WebAssembly file size
    WASM_FILE="${BASE_NAME}.wasm"
    if [ -f "$WASM_FILE" ]; then
        WASM_SIZE=$(ls -lh "$WASM_FILE" | awk '{print $5}')
        echo "   WebAssembly size: $WASM_SIZE"
    fi

else
    echo "❌ WebAssembly compilation failed"
    exit 1
fi