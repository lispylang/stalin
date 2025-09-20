# Stalin Compiler - TODO List

## Immediate Priority (Phase 1 Completion)

### 1. Fix 64-bit Compatibility Issues
- [ ] Generate stalin-ARM64.c from working x86_64 Stalin
- [ ] Fix pointer cast warnings (3600+ occurrences)
- [ ] Update type tag system for 64-bit pointers
- [ ] Fix structure field alignments for ARM64

### 2. Complete Boehm GC Integration
- [ ] Fix Boehm GC 6.8 build for ARM64 Darwin
- [ ] Replace gc_stub.c with proper GC implementation
- [ ] Test memory management under load
- [ ] Verify GC performance metrics

### 3. Bootstrap Strategy
- [ ] Option A: Cross-compile from x86_64 Linux VM
- [ ] Option B: Use Chez Scheme to bootstrap
- [ ] Option C: Create compatibility shim for 32-bit code
- [ ] Document chosen bootstrap path

## Near Term (Q4 2025)

### 4. Build System Improvements
- [ ] Convert to CMake build system
- [ ] Add proper architecture detection
- [ ] Create automated build scripts for all platforms
- [ ] Add continuous integration with GitHub Actions

### 5. Testing Infrastructure
- [ ] Create comprehensive test suite
- [ ] Add benchmark runner script
- [ ] Implement regression testing
- [ ] Document test coverage metrics

### 6. Platform Support
- [ ] Native ARM64/M1/M2 code generation
- [ ] Full 64-bit support on all platforms
- [ ] Windows WSL2 compatibility
- [ ] Docker multi-architecture images

## Medium Term (Q1 2026)

### 7. Compiler Improvements
- [ ] Fix remaining compiler warnings
- [ ] Update to C11 standard
- [ ] Improve error messages
- [ ] Add debugging symbols support

### 8. Documentation
- [ ] Complete developer documentation
- [ ] Create user manual
- [ ] Add code comments to stalin.sc
- [ ] Document internal architecture

### 9. Modern Features
- [ ] Basic REPL functionality
- [ ] Module system design
- [ ] Package manager integration planning
- [ ] IDE support (VS Code extension)

## Long Term (2026+)

### 10. Lispy Transformation
- [ ] R7RS compliance roadmap
- [ ] Interactive development environment
- [ ] JIT compilation research
- [ ] Web Assembly target
- [ ] GPU compute exploration

## Known Bugs to Fix

1. **Critical**: Runtime failure on ARM64 due to pointer size mismatch
2. **High**: Boehm GC doesn't compile cleanly on modern systems
3. **Medium**: X11 library detection fails on macOS
4. **Low**: Excessive compiler warnings need suppression

## Technical Debt

1. Remove hardcoded 32-bit assumptions throughout codebase
2. Modernize C code to current standards
3. Replace deprecated functions
4. Improve build system robustness
5. Add proper error handling

## Research Items

1. Investigate LLVM backend possibility
2. Study modern GC alternatives (mimalloc, etc.)
3. Explore incremental compilation options
4. Research modern optimization techniques
5. Consider Rust rewrite of runtime

## Community Tasks

1. Set up Discord/Slack channel
2. Create contributing guidelines
3. Establish code review process
4. Plan first release milestone
5. Engage with Scheme community

## Notes

- Current blocker: Need working Stalin binary to generate ARM64 code
- Alternative: Bootstrap from different Scheme implementation
- Priority: Get minimal working compiler first, optimize later
- Timeline: Aim for working ARM64 version by end of 2025