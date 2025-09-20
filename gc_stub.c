// Minimal GC stub for Stalin compilation testing
// This provides just enough GC functionality to compile Stalin

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Basic allocation functions
void* GC_malloc(size_t size) {
    return calloc(1, size);
}

void* GC_malloc_atomic(size_t size) {
    return calloc(1, size);
}

void* GC_malloc_uncollectable(size_t size) {
    return calloc(1, size);
}

void* GC_malloc_atomic_uncollectable(size_t size) {
    return calloc(1, size);
}

void* GC_realloc(void* ptr, size_t size) {
    return realloc(ptr, size);
}

void GC_free(void* ptr) {
    free(ptr);
}

// Initialization and collection
void GC_init(void) {
    // No-op for stub
}

void GC_gcollect(void) {
    // No-op for stub
}

void GC_enable_incremental(void) {
    // No-op for stub
}

// Memory stats
size_t GC_get_heap_size(void) {
    return 0;
}

size_t GC_get_free_bytes(void) {
    return 0;
}

// Finalization
void GC_register_finalizer(void* obj, void (*fn)(void*, void*),
                           void* cd, void (**ofn)(void*, void*),
                           void** ocd) {
    // No-op for stub
}

// Thread support stubs
void GC_allow_register_threads(void) {
    // No-op for stub
}

// Debugging
void GC_dump(void) {
    printf("GC stub - no heap to dump\n");
}