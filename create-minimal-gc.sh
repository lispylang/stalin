#!/bin/bash
# Create a minimal GC stub for development
# This is a temporary solution until proper GC is built

echo "Creating minimal GC stub for Stalin development..."

mkdir -p include

# Create minimal gc.h if it doesn't exist
if [ ! -f "include/gc.h" ]; then
    cat > include/gc.h << 'EOF'
#ifndef GC_H
#define GC_H

#include <stdlib.h>
#include <stddef.h>

/* Basic GC functions for Stalin */
#define GC_malloc(n) malloc(n)
#define GC_malloc_atomic(n) malloc(n)
#define GC_malloc_uncollectable(n) malloc(n)
#define GC_malloc_atomic_uncollectable(n) malloc(n)
#define GC_realloc(p, n) realloc(p, n)
#define GC_free(p) free(p)
#define GC_register_displacement(n)
#define GC_init()
#define GC_gcollect()
#define GC_enable_incremental()
#define GC_disable()
#define GC_is_disabled() 0

typedef void (*GC_finalization_proc)(void *obj, void *client_data);
#define GC_register_finalizer(p, f, d, of, od)
#define GC_register_finalizer_ignore_self(p, f, d, of, od)

#define GC_MALLOC(sz) GC_malloc(sz)
#define GC_MALLOC_ATOMIC(sz) GC_malloc_atomic(sz)
#define GC_REALLOC(p, sz) GC_realloc(p, sz)
#define GC_FREE(p) GC_free(p)

/* Memory allocation with explicit type */
#define GC_NEW(t) ((t*)GC_MALLOC(sizeof(t)))
#define GC_NEW_ATOMIC(t) ((t*)GC_MALLOC_ATOMIC(sizeof(t)))

/* Thread support stubs */
#define GC_allow_register_threads()
#define GC_threads_init()

/* Statistics stubs */
#define GC_get_heap_size() 0
#define GC_get_free_bytes() 0
#define GC_get_total_bytes() 0

#endif /* GC_H */
EOF
fi

# Create gc_config_macros.h if it doesn't exist
if [ ! -f "include/gc_config_macros.h" ]; then
    cat > include/gc_config_macros.h << 'EOF'
#ifndef GC_CONFIG_MACROS_H
#define GC_CONFIG_MACROS_H

#define GC_THREADS 0
#define GC_DARWIN_THREADS 0
#define GC_PTHREADS 0

#endif
EOF
fi

# Create minimal GC implementation
cat > gc_minimal.c << 'EOF'
/* Minimal GC implementation for Stalin */
#include <stdlib.h>

void GC_init() {}
void GC_enable_incremental() {}
void GC_disable() {}
void GC_gcollect() {}
int GC_is_disabled() { return 0; }
void GC_allow_register_threads() {}
void GC_threads_init() {}
size_t GC_get_heap_size() { return 0; }
size_t GC_get_free_bytes() { return 0; }
size_t GC_get_total_bytes() { return 0; }
void GC_register_displacement(size_t n) {}
EOF

# Compile the minimal GC
echo "Compiling minimal GC..."
gcc -c -O2 gc_minimal.c -o gc_minimal.o 2>/dev/null || cc -c -O2 gc_minimal.c -o gc_minimal.o

# Create the library
echo "Creating libgc.a..."
ar rv include/libgc.a gc_minimal.o 2>/dev/null
ranlib include/libgc.a

# Clean up
rm -f gc_minimal.c gc_minimal.o

echo "✅ Minimal GC stub created at include/libgc.a"
echo "⚠️  Note: This is for development only, not for production use!"
ls -lh include/libgc.a include/gc.h include/gc_config_macros.h