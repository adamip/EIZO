TOP=${PWD}
# you can add toolchain path here
INC=${TOP}/include
SRC=${TOP}/src
BIN=${TOP}/bin
# we have determined the toolchain prefix, let's determine CC/LD to be used here
CC=${HOST_PREFIX}gcc

.PHONY: all
OBJCPY    := objcopy

SRCFILE1  := $(SRC)/ezio_g500.c  $(SRC)/lcd_ctrl.c
SRCFILE2  := $(SRC)/ezio_300.c  $(SRC)/lcd_ctrl.c

BINFILE1  := $(BIN)/ezio_g500_api
BINFILE2  := $(BIN)/ezio_300_api

OBJPARA         := -R .comment -R .note.ABI-tag -R .gnu.version
CCPARA          := -Os -s -I ./ -L ./

default : all

init_env:
	@ [ -d ${BIN} ]  || mkdir -p ${BIN}

300: init_env
	touch ${INC}/cas.h
	$(CC) -DEZIO_300_CONFIG $(CCPARA) $(SRCFILE2)  -o $(BINFILE2)
	- ln -s ${BIN}/ezio_300_api ${BIN}/ezio_g300_api
g500: init_env
	touch ${INC}/cas.h
	$(CC) -DEZIO_G500_CONFIG $(CCPARA) $(SRCFILE1)  -o $(BINFILE1)

all: 300 g500

clean:
	rm -rf ${BIN} ${INC}/cas.h
