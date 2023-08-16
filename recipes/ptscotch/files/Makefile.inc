EXE =
LIB = .a
OBJ = .o

MAKE = make
AR = ar
ARFLAGS = -ruv
CAT = cat
CCS = $(CC)
CCP = mpicc
CCD = $(CC)

CLIBFLAGS =
CP = cp
LEX = flex -Pscotchyy -olex.yy.c
LN = ln
MKDIR = mkdir -p
MV = mv
RANLIB = ranlib
YACC = bison -pscotchyy -y -b y
