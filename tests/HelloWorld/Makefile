ROOT = ../..
TARGETS = hello

build:: hello

include $(ROOT)/common.mk

CC = $(ROOT)/szcc $(SZCFLAGS)
CXX = $(CC)
CXXFLAGS =

$(OBJS):: $(CC) $(ROOT)/LLVMStabilizer.$(SHLIB_SUFFIX)

test:: hello
	@echo $(INDENT)[test] Running 'hello'
	@echo
	@$(LD_PATH_VAR)=$(ROOT) ./hello
	@echo
