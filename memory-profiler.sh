#!/bin/bash
# Memory profiling script for Stalin Scheme programs
# Provides memory usage analysis and leak detection

set -e

PROGRAM=""
TOOL="valgrind"
OUTPUT=""
PROFILE_TYPE="basic"
VERBOSE=false

usage() {
    echo "Usage: $0 [OPTIONS] <program>"
    echo ""
    echo "Memory profiling options for Stalin Scheme programs"
    echo ""
    echo "Options:"
    echo "  -t <tool>       Profiling tool: valgrind, heaptrack, massif (default: valgrind)"
    echo "  -p <type>       Profile type: basic, detailed, leaks, heap (default: basic)"
    echo "  -o <output>     Output file for profile data"
    echo "  -v              Verbose output"
    echo "  -h              Show this help"
    echo ""
    echo "Profile types:"
    echo "  basic          Basic memory usage summary"
    echo "  detailed       Detailed allocation tracking"
    echo "  leaks          Memory leak detection"
    echo "  heap           Heap profiling with growth analysis"
    echo ""
    echo "Examples:"
    echo "  $0 myprogram                    # Basic memory check"
    echo "  $0 -p leaks myprogram           # Leak detection"
    echo "  $0 -t massif -p heap myprogram  # Heap profiling"
    exit 0
}

log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
    exit 1
}

log_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# Parse command line arguments
while getopts "t:p:o:vh" opt; do
    case $opt in
        t) TOOL="$OPTARG" ;;
        p) PROFILE_TYPE="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        v) VERBOSE=true ;;
        h) usage ;;
        \?) log_error "Invalid option: -$OPTARG" ;;
    esac
done

shift $((OPTIND-1))

if [ $# -eq 0 ]; then
    log_error "No program specified. Use -h for help."
fi

PROGRAM="$1"

# Validate program exists
if [ ! -f "$PROGRAM" ]; then
    log_error "Program not found: $PROGRAM"
fi

# Make sure program is executable
if [ ! -x "$PROGRAM" ]; then
    log_error "Program is not executable: $PROGRAM"
fi

# Set default output filename
if [ -z "$OUTPUT" ]; then
    OUTPUT="${PROGRAM}_memory_profile"
fi

log_info "Memory profiling $PROGRAM..."
log_info "Tool: $TOOL, Type: $PROFILE_TYPE"

case $TOOL in
    valgrind)
        # Check if valgrind is available
        if ! command -v valgrind &> /dev/null; then
            log_error "Valgrind not found. Install with: sudo apt-get install valgrind"
        fi

        case $PROFILE_TYPE in
            basic)
                log_info "Running basic memory check with Valgrind..."
                valgrind --tool=memcheck --leak-check=summary --show-leak-kinds=all \
                         --track-origins=yes --log-file="$OUTPUT.valgrind" \
                         ./"$PROGRAM"
                ;;
            detailed)
                log_info "Running detailed memory analysis with Valgrind..."
                valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all \
                         --track-origins=yes --show-reachable=yes \
                         --log-file="$OUTPUT.detailed.valgrind" \
                         ./"$PROGRAM"
                ;;
            leaks)
                log_info "Running leak detection with Valgrind..."
                valgrind --tool=memcheck --leak-check=full --show-leak-kinds=definite,possible \
                         --track-origins=yes --suppressions=/dev/null \
                         --log-file="$OUTPUT.leaks.valgrind" \
                         ./"$PROGRAM"
                ;;
            heap)
                log_info "Running heap profiling with Valgrind Massif..."
                valgrind --tool=massif --massif-out-file="$OUTPUT.massif" \
                         ./"$PROGRAM"

                if command -v ms_print &> /dev/null; then
                    ms_print "$OUTPUT.massif" > "$OUTPUT.massif.txt"
                    log_info "Heap profile saved to $OUTPUT.massif.txt"
                fi
                ;;
            *)
                log_error "Invalid profile type for valgrind: $PROFILE_TYPE"
                ;;
        esac
        ;;

    heaptrack)
        # Check if heaptrack is available
        if ! command -v heaptrack &> /dev/null; then
            log_error "Heaptrack not found. Install with: sudo apt-get install heaptrack"
        fi

        log_info "Running heap tracking with Heaptrack..."
        heaptrack -o "$OUTPUT.heaptrack" ./"$PROGRAM"

        if command -v heaptrack_print &> /dev/null; then
            heaptrack_print "$OUTPUT.heaptrack.gz" > "$OUTPUT.heaptrack.txt"
            log_info "Heap analysis saved to $OUTPUT.heaptrack.txt"
        fi
        ;;

    massif)
        # Use valgrind's massif tool
        if ! command -v valgrind &> /dev/null; then
            log_error "Valgrind not found. Install with: sudo apt-get install valgrind"
        fi

        log_info "Running Massif heap profiler..."
        valgrind --tool=massif --time-unit=B --detailed-freq=1 \
                 --max-snapshots=200 --massif-out-file="$OUTPUT.massif" \
                 ./"$PROGRAM"

        if command -v ms_print &> /dev/null; then
            ms_print "$OUTPUT.massif" > "$OUTPUT.massif.txt"
            log_info "Massif profile saved to $OUTPUT.massif.txt"
        fi
        ;;

    *)
        log_error "Unknown profiling tool: $TOOL"
        ;;
esac

log_success "Memory profiling completed!"

# Show summary
echo ""
echo "Profile Summary:"
echo "==============="

case $TOOL in
    valgrind)
        if [ -f "$OUTPUT.valgrind" ] || [ -f "$OUTPUT.detailed.valgrind" ] || [ -f "$OUTPUT.leaks.valgrind" ]; then
            echo "Valgrind reports generated:"
            ls -lh "$OUTPUT"*.valgrind 2>/dev/null || true

            # Extract key information
            for report in "$OUTPUT"*.valgrind; do
                if [ -f "$report" ]; then
                    echo ""
                    echo "$(basename "$report"):"
                    grep -E "(ERROR SUMMARY|definitely lost|indirectly lost|possibly lost)" "$report" | head -5
                fi
            done
        fi

        if [ -f "$OUTPUT.massif" ]; then
            echo ""
            echo "Massif heap profile: $OUTPUT.massif"
            if [ -f "$OUTPUT.massif.txt" ]; then
                echo "Peak heap usage:"
                grep -A 5 "Peak" "$OUTPUT.massif.txt" | head -10
            fi
        fi
        ;;

    heaptrack)
        if [ -f "$OUTPUT.heaptrack.txt" ]; then
            echo "Heaptrack analysis: $OUTPUT.heaptrack.txt"
            echo ""
            echo "Allocation summary:"
            grep -A 10 "MOST CALLS" "$OUTPUT.heaptrack.txt" | head -15
        fi
        ;;

    massif)
        if [ -f "$OUTPUT.massif.txt" ]; then
            echo "Massif profile: $OUTPUT.massif.txt"
            echo ""
            echo "Heap growth:"
            grep -A 5 "Peak" "$OUTPUT.massif.txt" | head -10
        fi
        ;;
esac

# Show file sizes and locations
echo ""
echo "Generated files:"
ls -lh "$OUTPUT"* 2>/dev/null || echo "No profile files found"

echo ""
echo "Tips:"
echo "- For Stalin programs, focus on garbage collection behavior"
echo "- Check for memory leaks in C extensions or FFI calls"
echo "- Monitor heap growth during long-running computations"
echo "- Use debug builds (-mdbg) for better stack traces"