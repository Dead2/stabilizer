
CC = gcc
CXX = g++

CFLAGS = -Os
CXXFLAGS = $(CFLAGS)

SZCFLAGS = -frontend=clang
LD_PATH_VAR = LD_LIBRARY_PATH
CXXLIB = $(CXX) -shared
