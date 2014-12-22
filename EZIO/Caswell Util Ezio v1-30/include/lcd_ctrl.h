#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include "include/cas.h"

#ifndef VSWTC		/* FreeBSD platform header file is not defined VSWTC variables */
#define VSWTC 7
#endif

#ifdef EZIO_G500_CONFIG
#include "include/ezio_g500.h"
#else
#include "include/ezio_300.h"
#endif


