#!/usr/bin/env python3
"""
Stalin Boehm GC ARM64 Compatibility Fix

This script fixes compatibility issues with the ancient Boehm Garbage Collector (v6.8)
that comes with Stalin when building on modern ARM64 architectures. The original GC was
written in 2006 and predates ARM64, causing compilation failures.

The script performs two critical fixes:
1. Replaces the "unknown machine type" error with proper ARM64 architecture definitions
2. Adds MACH_TYPE definitions to if_mach.c for ARM64 build tool compatibility

Author: Claude Code Development Team
Date: 2024
License: Same as Stalin (GNU GPL v2)
"""

import os
import sys

def fix_gc_config():
    """
    Fix Boehm GC configuration for ARM64 architecture support.

    This function addresses two main issues:
    1. The gcconfig.h file has an "unknown machine type" error for ARM64
    2. The if_mach.c build utility lacks MACH_TYPE definitions for ARM64

    Returns:
        bool: True if fix was successfully applied, False otherwise
    """
    # Path to the Boehm GC configuration header file
    # This file contains architecture-specific settings for memory management
    config_file = 'gc6.8/include/private/gcconfig.h'

    # Verify the GC source has been extracted and config file exists
    if not os.path.exists(config_file):
        print(f"Error: {config_file} not found")
        print("Make sure gc6.8.tar.gz has been extracted first")
        return False

    # Read the entire configuration file into memory
    # We need to do a text replacement on the problematic line
    with open(config_file, 'r') as f:
        content = f.read()

    # The original GC has this line that causes compilation failure on ARM64:
    # "	--> unknown machine type"
    # This appears when the preprocessor encounters ARM64 but doesn't know how to handle it
    old_line = '\t--> unknown machine type'

    # Replace with proper ARM64 architecture definitions
    # This tells the GC how to handle 64-bit ARM processors
    new_lines = '''#     define mach_type_known
#     ifdef __LP64__
#       undef ARM32
#       define AARCH64
#       define CPP_WORDSZ 64
#       define ALIGNMENT 8
#     else
#       define ALIGNMENT 4
#     endif'''

    # Check if the problematic line exists and replace it
    if old_line in content:
        # Perform the text replacement
        content = content.replace(old_line, new_lines)

        # Write the modified content back to the file
        with open(config_file, 'w') as f:
            f.write(content)

        # SECOND FIX: Handle if_mach.c compilation utility
        # The if_mach.c program is used during GC build to conditionally compile
        # architecture-specific code, but it lacks MACH_TYPE definitions for ARM64
        if_mach_file = 'gc6.8/if_mach.c'

        if os.path.exists(if_mach_file):
            with open(if_mach_file, 'r') as f:
                if_mach_content = f.read()

            # Look for the gcconfig.h include and add MACH_TYPE definitions after it
            # MACH_TYPE is used by if_mach to identify the current architecture
            if '# include "private/gcconfig.h"' in if_mach_content:
                # Create the fix that adds MACH_TYPE definitions for ARM architectures
                fix_lines = '''# include "private/gcconfig.h"

#ifndef MACH_TYPE
#  ifdef AARCH64
#    define MACH_TYPE "AARCH64"
#  elif defined(ARM32)
#    define MACH_TYPE "ARM32"
#  else
#    define MACH_TYPE "UNKNOWN"
#  endif
#endif
'''
                # Replace the include line with include + definitions
                if_mach_content = if_mach_content.replace('# include "private/gcconfig.h"', fix_lines)

                # Write the modified if_mach.c back
                with open(if_mach_file, 'w') as f:
                    f.write(if_mach_content)

        print("GC ARM64 fix applied successfully")
        print("- Fixed gcconfig.h ARM64 architecture recognition")
        print("- Added MACH_TYPE definitions to if_mach.c")
        return True
    else:
        print("Warning: Target line not found in gcconfig.h")
        print("This could mean:")
        print("  1. The fix was already applied")
        print("  2. Different version of Boehm GC is being used")
        print("  3. The file structure changed")
        return False

if __name__ == '__main__':
    """
    Main entry point when script is run directly.

    This script is designed to be called from build-modern during the Stalin
    compilation process to automatically fix ARM64 compatibility issues.

    Exit codes:
      0: Success - fixes applied successfully
      1: Failure - could not apply fixes
    """
    print("Stalin Boehm GC ARM64 Compatibility Fixer")
    print("==========================================")

    success = fix_gc_config()

    if success:
        print("All fixes applied successfully!")
    else:
        print("Failed to apply some fixes - check warnings above")

    # Exit with appropriate code for shell scripts
    sys.exit(0 if success else 1)