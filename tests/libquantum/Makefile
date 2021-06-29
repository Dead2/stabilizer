ROOT = ../..
TARGETS = libquantum

build:: libquantum

include $(ROOT)/common.mk

CC = $(ROOT)/szc $(SZCFLAGS)
CXX = $(CC)
#CFLAGS = -DSPEC_CPU -DSPEC_CPU_MACOSX
CFLAGS = -DSPEC_CPU -DSPEC_CPU_LINUX
CXXFLAGS =
LIBFLAGS += -lm

$(OBJS):: $(ROOT)/szc $(ROOT)/LLVMStabilizer.$(SHLIB_SUFFIX)

test:: libquantum
	@echo $(INDENT)[test] Running 'libquantum'
	@echo
	@$(LD_PATH_VAR)=$(ROOT) ./libquantum 128
	@echo
