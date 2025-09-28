#include <stddef.h>
#include <assert.h>
#include <time.h>
#include <alloca.h>
#include <gc.h>
#include <string.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#ifdef __GNUC__
#define NORETURN __attribute__ ((noreturn))
#else
#define NORETURN
#endif
#define ALIGN(p) if (((uintptr_t)p)%8!=0) p += 8-(((uintptr_t)p)%8)
#define IMIN(x,y) (x<y?x:y)
#define IMAX(x,y) (x>y?x:y)
#define RMIN(x,y) (x<y?x:y)
#define RMAX(x,y) (x>y?x:y)
struct rectangular {float r; float i;};
int c;
void stalin_panic(char *message) NORETURN;
void stalin_panic(char *message)
{fprintf(stderr, "%s\n", message); exit(-1);}
void backtrace(char *file_name, unsigned int line_number, unsigned int character_number);
void backtrace(char *file_name, unsigned int line_number, unsigned int character_number)
{fprintf(stderr, "\n%s:%d:%d:", file_name, line_number, character_number);}
void backtrace_internal(char *name);
void backtrace_internal(char *name) {fprintf(stderr, "\nIn %s\n", name);}
int ipow(int x, int y);
int ipow(int x, int y)
{int i, r = 1;
 for (i = 0; i<y; i++) r *= x;
 return r;}
#define STRUCTURE_TYPE24753 1024
#define EXTERNAL_SYMBOL_TYPE 1028
#define FALSE_TYPE 1032
#define NULL_TYPE 1036
#define TRUE_TYPE 1040
#define STRING_TYPE 1044
#define FIXNUM_TYPE 1048
#define FLONUM_TYPE 1052
#define STRUCTURE_TYPE27745 1056
#define NATIVE_PROCEDURE_TYPE7426 1060
#define STRUCTURE_TYPE27698 1064
#define STRUCTURE_TYPE27501 1068
#define STRUCTURE_TYPE27650 1072
#define NATIVE_PROCEDURE_TYPE7430 1076
#define HEADED_VECTOR_TYPE27896 1080
#define STRUCTURE_TYPE24757 1084
#define NATIVE_PROCEDURE_TYPE7431 1088
#define OUTPUT_PORT_TYPE 1092
#define NATIVE_PROCEDURE_TYPE7429 1096
#define NATIVE_PROCEDURE_TYPE7822 1100
#define NATIVE_PROCEDURE_TYPE7404 1104
#define STRUCTURE_TYPE27692 1108
#define EOF_OBJECT_TYPE 1112
#define NATIVE_PROCEDURE_TYPE7435 1116
#define NATIVE_PROCEDURE_TYPE7423 1120
#define STRUCTURE_TYPE27694 1124
#define NATIVE_PROCEDURE_TYPE15963 1128
#define NATIVE_PROCEDURE_TYPE7406 1132
#define NATIVE_PROCEDURE_TYPE7422 1136
#define STRUCTURE_TYPE27747 1140
#define STRUCTURE_TYPE27858 1144
#define NATIVE_PROCEDURE_TYPE7418 1148
#define STRUCTURE_TYPE27510 1152
#define NATIVE_PROCEDURE_TYPE7420 1156
#define NATIVE_PROCEDURE_TYPE7433 1160
#define STRUCTURE_TYPE27769 1164
#define STRUCTURE_TYPE27761 1168
#define STRUCTURE_TYPE27621 1172
#define STRUCTURE_TYPE27669 1176
#define STRUCTURE_TYPE27779 1180
#define STRUCTURE_TYPE27673 1184
#define STRUCTURE_TYPE27908 1188
#define STRUCTURE_TYPE27756 1192
#define STRUCTURE_TYPE27750 1196
#define STRUCTURE_TYPE27753 1200
#define STRUCTURE_TYPE27776 1204
#define NATIVE_PROCEDURE_TYPE19068 1208
#define NATIVE_PROCEDURE_TYPE19067 1212
#define NATIVE_PROCEDURE_TYPE7421 1216
#define NATIVE_PROCEDURE_TYPE7415 1220
#define NATIVE_PROCEDURE_TYPE7432 1224
#define NATIVE_PROCEDURE_TYPE7410 1228
#define NATIVE_PROCEDURE_TYPE6005 1232
#define NATIVE_PROCEDURE_TYPE5969 1236
#define NATIVE_PROCEDURE_TYPE22485 1240
#define NATIVE_PROCEDURE_TYPE5985 1244
#define NATIVE_PROCEDURE_TYPE6013 1248
#define NATIVE_PROCEDURE_TYPE5977 1252
#define NATIVE_PROCEDURE_TYPE22461 1256
#define NATIVE_PROCEDURE_TYPE22493 1260
#define NATIVE_PROCEDURE_TYPE6009 1264
#define NATIVE_PROCEDURE_TYPE5973 1268
#define NATIVE_PROCEDURE_TYPE22489 1272
#define NATIVE_PROCEDURE_TYPE5989 1276
#define NATIVE_PROCEDURE_TYPE5981 1280