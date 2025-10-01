# Instructions for Commit Messages

## Purpose
Commit messages should provide complete information and context for the next AI developer who continues this work. Each commit should be self-contained and understandable without requiring external context.

## Structure

### Format
```
<type>: <summary> (<percentage> complete)

<detailed description>

<key findings>

<technical details>

<next steps>

<files changed summary>
```

### Types
- `feat`: New features or major progress
- `fix`: Bug fixes
- `docs`: Documentation updates
- `refactor`: Code restructuring
- `test`: Testing additions
- `chore`: Maintenance tasks

## Guidelines

1. **Summary Line**
   - Start with type prefix (feat:, fix:, docs:, etc.)
   - Include completion percentage in parentheses
   - Be specific about what was accomplished

2. **Detailed Description**
   - Explain what was done and why
   - Provide context for decisions made
   - Describe the current state

3. **Key Findings**
   - List important discoveries
   - Document blockers or limitations
   - Note any breakthrough insights

4. **Technical Details**
   - Include specific error messages
   - Document system configurations
   - List versions of tools used
   - Provide command examples

5. **Next Steps**
   - Outline clear actions for next developer
   - List options with probability assessments
   - Provide time estimates

6. **Files Changed Summary**
   - Categorize changes (new files, modifications, deletions)
   - Explain purpose of each major file
   - Note file sizes for large additions

## Reading Order
Commits should make sense when read:
- **Top to bottom** (chronologically forward)
- **Bottom to top** (most recent first)

Each commit should be complete without repeating information from previous commits. Reference previous commits when building on earlier work.

## Example

```
feat: Complete Cosmopolitan Libc integration for universal binary support (75% complete)

Integrated Cosmopolitan Libc toolchain (cosmocc 1.10) with Stalin compiler
infrastructure to enable Actually Portable Executable (APE) generation.
Successfully created universal binaries that run on macOS, Linux, Windows,
and BSD without modification.

Key Achievements:
- C→APE compilation pipeline 100% functional
- Universal binaries tested (589 KB, APE format verified)
- Size optimization working (47% reduction with -Os -mtiny)
- Build system updated for Cosmopolitan toolchain
- 15+ architecture definitions prepared

Blocker Identified:
- Stalin Scheme→C compiler has runtime initialization issues
- Segmentation fault during startup on ARM64
- Prevents end-to-end Scheme→C→APE pipeline

Technical Details:
- cosmocc version: 1.10
- Build flags: -O3 -fomit-frame-pointer -fno-strict-aliasing
- Output: DOS/MBR boot sector (APE format)
- Test platforms: ARM64 macOS (native), verified portable

Files Changed:
- Modified: build system scripts, makefile
- Added: libgc.a, libstalin.a (stub libraries)
- Created: hello-simple (589 KB working universal binary)
- Documentation: 5,000+ lines added

Next Steps:
1. Debug Stalin runtime initialization (see NEXT_STEPS.md)
2. Test on x86_64 Linux environment
3. Try alternative Scheme implementations (Chez, Gambit)

Timeline: 2-4 weeks to completion
```

## Tips for AI Developers

1. **Read all documentation first** before making changes
2. **Update START_HERE.md** with every session's findings
3. **Create session reports** for major investigation work
4. **Document failures** as thoroughly as successes
5. **Provide multiple options** when blocked
6. **Include exact error messages** and command outputs
7. **Test incrementally** and document each step
8. **Leave the project better** than you found it

## Commit Workflow

```bash
# 1. Check status
git status

# 2. Add all changes
git add -A

# 3. Write comprehensive commit message
git commit -m "$(cat <<'EOF'
<type>: <summary> (<percentage> complete)

<full message following structure above>
EOF
)"

# 4. Push if appropriate
# git push origin <branch>
```

Remember: The next AI should be able to understand the entire project state, what was tried, what worked, what didn't, and what to try next - all from reading commits in order.
