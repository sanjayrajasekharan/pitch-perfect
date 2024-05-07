ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := audio.o

else

# We are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /usr/src/linux-headers-$(shell uname -r)
        PWD := $(shell pwd)/driver

default: module caller

module:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

make_wav.o:
	cc -c wavfile_construction/make_wav.c wavfile_construction/make_wav.h

caller.o:
	cc -c caller.c

caller: make_wav.o caller.o
	cc -o caller caller.o make_wav.o

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} caller caller.o make_wav.o


endif 
