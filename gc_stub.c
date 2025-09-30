/*
 * Garbage Collector Stub for Stalin Scheme
 * Minimal GC implementation for bootstrapping
 */

#include <stdlib.h>
#include <string.h>

/* GC Function Stubs */
void *GC_malloc(size_t size) {
    return malloc(size);
}

void *GC_malloc_atomic(size_t size) {
    return malloc(size);
}

void *GC_realloc(void *ptr, size_t size) {
    return realloc(ptr, size);
}

void GC_free(void *ptr) {
    free(ptr);
}

void GC_init(void) {
    /* No initialization needed for stub */
}

void GC_gcollect(void) {
    /* No garbage collection in stub */
}

size_t GC_get_heap_size(void) {
    return 0;
}

size_t GC_get_free_bytes(void) {
    return 0;
}

void GC_set_warn_proc(void (*proc)(char *, int)) {
    /* Ignore warning procedure */
}

/* Additional GC functions that might be needed */
void *GC_malloc_uncollectable(size_t size) {
    return malloc(size);
}

void *GC_malloc_atomic_uncollectable(size_t size) {
    return malloc(size);
}

void GC_register_finalizer(void *obj, void (*fn)(void *, void *),
                          void *cd, void (**ofn)(void *, void *),
                          void **ocd) {
    /* No finalizers in stub */
}

int GC_invoke_finalizers(void) {
    return 0;
}

void GC_enable_incremental(void) {
    /* No incremental GC in stub */
}

void GC_disable(void) {
    /* No-op */
}

void GC_enable(void) {
    /* No-op */
}