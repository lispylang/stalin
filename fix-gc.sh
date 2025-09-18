#!/bin/bash
# Fix Boehm GC for ARM64 architecture

cd gc6.8

# Find and replace the problematic line in gcconfig.h
cat include/private/gcconfig.h | sed '/--> unknown machine type/c\
#     define mach_type_known\
#     ifdef __LP64__\
#       undef ARM32\
#       define AARCH64\
#       define CPP_WORDSZ 64\
#       define ALIGNMENT 8\
#     else\
#       define ALIGNMENT 4\
#     endif' > include/private/gcconfig.h.tmp

mv include/private/gcconfig.h.tmp include/private/gcconfig.h

echo "GC ARM64 fix applied successfully"