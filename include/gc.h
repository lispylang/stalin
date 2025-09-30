#ifndef GC_H
#define GC_H
#include <stdlib.h>
void *GC_malloc(size_t size);
void *GC_malloc_atomic(size_t size);
void *GC_realloc(void *ptr, size_t size);
void GC_free(void *ptr);
void GC_init(void);
void GC_gcollect(void);
size_t GC_get_heap_size(void);
size_t GC_get_free_bytes(void);
void GC_set_warn_proc(void (*proc)(char *, int));
void *GC_malloc_uncollectable(size_t size);
void *GC_malloc_atomic_uncollectable(size_t size);
void GC_register_finalizer(void *obj, void (*fn)(void *, void *), void *cd, void (**ofn)(void *, void *), void **ocd);
int GC_invoke_finalizers(void);
void GC_enable_incremental(void);
void GC_disable(void);
void GC_enable(void);
#endif
