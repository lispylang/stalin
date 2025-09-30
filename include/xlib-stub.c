/*
 * X11/Xlib Stub for Stalin Scheme Cosmopolitan Build
 * Minimal X11 stubs to avoid dependencies
 */

#include <stdlib.h>

/* Basic X11 type stubs */
typedef struct {
    int dummy;
} Display;

typedef unsigned long Window;
typedef unsigned long Pixmap;
typedef unsigned long Atom;
typedef unsigned long Time;
typedef struct { int dummy; } XEvent;
typedef struct { int dummy; } *GC;
typedef struct { int dummy; } Visual;
typedef struct { int dummy; } Screen;
typedef struct { int dummy; } XSetWindowAttributes;
typedef struct { int dummy; } XWindowAttributes;
typedef struct { int dummy; } XColor;
typedef struct { int dummy; } Colormap;
typedef struct { int dummy; } XFontStruct;
typedef struct { int dummy; } XImage;
typedef struct { int dummy; } XGCValues;

/* X11 function stubs - all return failure/null */
Display* XOpenDisplay(const char* display_name) { return NULL; }
int XCloseDisplay(Display* display) { return 0; }
Window XCreateSimpleWindow(Display* d, Window parent, int x, int y, unsigned int width, unsigned int height, unsigned int border_width, unsigned long border, unsigned long background) { return 0; }
int XMapWindow(Display* display, Window w) { return 0; }
int XUnmapWindow(Display* display, Window w) { return 0; }
int XDestroyWindow(Display* display, Window w) { return 0; }
int XFlush(Display* display) { return 0; }
int XSync(Display* display, int discard) { return 0; }
int XNextEvent(Display* display, XEvent* event_return) { return 0; }
int XPending(Display* display) { return 0; }
GC XCreateGC(Display* display, Window d, unsigned long valuemask, XGCValues* values) { return NULL; }
int XFreeGC(Display* display, GC gc) { return 0; }
int XDrawPoint(Display* display, Window d, GC gc, int x, int y) { return 0; }
int XDrawLine(Display* display, Window d, GC gc, int x1, int y1, int x2, int y2) { return 0; }
int XDrawRectangle(Display* display, Window d, GC gc, int x, int y, unsigned int width, unsigned int height) { return 0; }
int XFillRectangle(Display* display, Window d, GC gc, int x, int y, unsigned int width, unsigned int height) { return 0; }
int XSetForeground(Display* display, GC gc, unsigned long foreground) { return 0; }
int XSetBackground(Display* display, GC gc, unsigned long background) { return 0; }
Window XDefaultRootWindow(Display* display) { return 0; }
int XDefaultScreen(Display* display) { return 0; }
unsigned long XBlackPixel(Display* display, int screen_number) { return 0; }
unsigned long XWhitePixel(Display* display, int screen_number) { return 0; }