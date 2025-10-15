# Changelog

All notable changes to the Stalin 64-bit port will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [0.11-64bit] - 2025-10-15

### Added
- **Comprehensive Test Suite**: Created complete testing infrastructure with smoke and integration tests
  - `tests/smoke/test-hello.sh`: Hello World test (basic I/O validation)
  - `tests/smoke/test-tak.sh`: TAK benchmark test (recursive function validation)
  - `tests/integration/test-div-iter.sh`: DIV benchmark test (iterative list processing)
  - `tests/run-tests.sh`: Master test runner with colored output
  - `tests/fixtures/`: Expected output files for all tests
  - `tests/README.md`: Complete test documentation

- **GitHub Actions CI/CD**: Automated testing on every push and pull request
  - Matrix testing on Ubuntu (AMD64) and macOS (ARM64)
  - Automatic dependency installation (Boehm GC)
  - Test artifact upload on failure for debugging
  - Fast feedback with smoke tests running first

- **64-bit Architecture Support**: Added support for modern 64-bit architectures
  - ARM64 architecture entry in `stalin.architectures` with 8-byte pointers
  - AMD64 architecture entry in `stalin.architectures` with 8-byte pointers
  - Updated `stalin-architecture-name` to detect arm64/Darwin and aarch64 as ARM64
  - Updated `stalin-architecture-name` to detect x86_64 as AMD64
  - Proper 64-bit type definitions: `uintptr_t` for tags, `size_t` for lengths

- **Helper Scripts**: Copied architecture detection scripts to project root
  - `stalin-architecture-name`: Architecture detection script
  - `stalin.architectures`: 64-bit architecture definitions

- **Verification Script**: Created `verify-64bit-port.sh` for manual validation
  - Checks binary exists and is 64-bit
  - Verifies all pattern conversions (3,425 changes)
  - Validates struct w49 tag field conversion
  - Confirms backup file integrity

### Fixed
- **Architecture Detection**: Fixed "Cannot find: stalin-architecture-name" error
  - stalin-64bit binary now correctly finds helper scripts
  - Architecture detection works on both ARM64 (macOS) and AMD64 (Linux)

### Changed
- **README.md**: Removed status and date lines for cleaner presentation
- **Architecture Detection**: Updated to recognize modern 64-bit platforms

### Technical Details

**64-bit Port Conversion (October 5, 2025):**
- Converted 699,719 lines of C code from 32-bit to 64-bit
- 3,426 automated pattern-based conversions
- Critical change: `struct w49` tag field from `unsigned` to `uintptr_t`
- Memory alignment: 4-byte → 8-byte alignment
- Type conversions: `unsigned` → `uintptr_t` for pointers, `size_t` for sizes

**Architecture Support:**
- ARM64: 8-byte pointers, proper alignment for Apple Silicon (M1/M2/M3)
- AMD64: 8-byte pointers, proper alignment for x86-64 Linux/BSD

## [0.11-32bit] - 2006

### Original Release
- Initial Stalin 0.11 release by Jeffrey Mark Siskind
- Supported 32-bit architectures: IA32, SPARC, MIPS, Alpha, ARM, M68K, PowerPC, S390
- Highly optimizing Scheme-to-C compiler
- Flow-directed lightweight closure conversion
- Aggressive optimization and inlining

---

## Version History

- **0.11-64bit** (2025-10-15): 64-bit port with comprehensive test suite and CI/CD
- **0.11** (2006): Original 32-bit release
- **0.10alpha2** (2005): Alpha release
- **0.9** (2004): Previous stable release

## Testing

Run the test suite:
```bash
./tests/run-tests.sh
```

CI/CD automatically validates on:
- Ubuntu Latest (AMD64)
- macOS Latest (ARM64)

## Contributing

When making changes:
1. Ensure tests pass: `./tests/run-tests.sh`
2. Add new tests for new features
3. Update this CHANGELOG
4. Follow conventional commit format: `type: description`

## Links

- Original Stalin: http://cobweb.cs.uga.edu/~dvanhorn/stalin/
- 64-bit Port Documentation: See `stalin-64bit-fix/` directory
- Test Documentation: See `tests/README.md`
