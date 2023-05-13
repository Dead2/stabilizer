cmake_minimum_required(VERSION 3.21)
# 3.21 - CMAKE_<LANG>_LINKER_LAUNCHER

project(stabilizer CXX)
enable_language(C)
# Enabling C language is required for find_package(LLVM)

option(BUILD_TESTING "Build the testing project." ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(GNUInstallDirs)


### libLLVMStabilizer.so
add_library(LLVMStabilizer MODULE)

find_package(LLVM ${STABILIZER_LLVM_VERSION} REQUIRED CONFIG)

target_include_directories(LLVMStabilizer PRIVATE ${LLVM_INCLUDE_DIRS})

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
target_compile_definitions(LLVMStabilizer PRIVATE ${LLVM_DEFINITIONS_LIST})

target_sources(LLVMStabilizer
  PRIVATE
    pass/IntrinsicLibcalls.h
    pass/LowerIntrinsics.cpp
    pass/Stabilizer.cpp
)

### libstabilizer.so
add_library(stabilizer MODULE)

target_include_directories(stabilizer
  PRIVATE
    Heap-Layers
    DieHard/src/include
    DieHard/src/include/math
    DieHard/src/include/rng
    DieHard/src/include/static
    DieHard/src/include/util
)

target_sources(stabilizer
  PRIVATE
    runtime/Arch.h
    runtime/Context.h
    runtime/Debug.cpp
    runtime/Debug.h
    runtime/Function.cpp
    runtime/Function.h
    runtime/FunctionLocation.h
    runtime/Heap.cpp
    runtime/Heap.h
    runtime/Intrinsics.cpp
    runtime/Jump.h
    runtime/MMapSource.h
    runtime/MemRange.h
    runtime/Trap.h
    runtime/Util.h
    runtime/libstabilizer.cpp
)

### SZCC
if (NOT ${CMAKE_CURRENT_BINARY_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/szcc ${CMAKE_CURRENT_BINARY_DIR}/szcc COPYONLY)
  file(CREATE_LINK ${CMAKE_CURRENT_BINARY_DIR}/szcc ${CMAKE_CURRENT_BINARY_DIR}/szcc++)
endif()

### Installation
install(
  TARGETS LLVMStabilizer stabilizer
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
  PROGRAMS
    ${CMAKE_CURRENT_BINARY_DIR}/szcc
    ${CMAKE_CURRENT_BINARY_DIR}/szcc++
  TYPE BIN
)

install(
  FILES LICENSE
  TYPE DOC
)

### Testing
if (BUILD_TESTING)

  # Generate toolchain file for the tests
  set(STABILIZER_ENV_LAUNCHER
    cmake -E env
      LD_LIBRARY_PATH=$<TARGET_FILE_DIR:LLVMStabilizer>:$ENV{LD_LIBRARY_PATH}
      SZ_CODE=1
      SZ_HEAP=1
      SZ_STACK=1
  )
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/StabilizerToolchain.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/StabilizerToolchain.cmake.tmp
    @ONLY
  )
  file(GENERATE
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/cmake/StabilizerToolchain.cmake
    INPUT ${CMAKE_CURRENT_BINARY_DIR}/cmake/StabilizerToolchain.cmake.tmp
  )

  # Add tests project
  include(ExternalProject)
  ExternalProject_Add(
    tests
    DEPENDS LLVMStabilizer stabilizer
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tests
    CMAKE_ARGS
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/cmake/StabilizerToolchain.cmake
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ""
  )

  # CRAP: workaround for launching tests from the root dir
  # https://discourse.cmake.org/t/testing-in-a-superbuild/1906
  ExternalProject_Get_Property(tests BINARY_DIR)
  file(RELATIVE_PATH ctest_dir "${CMAKE_CURRENT_BINARY_DIR}" "${BINARY_DIR}")
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CTestTestfile.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/CTestTestfile.cmake.tmp
  )
  file(GENERATE
    OUTPUT CTestTestfile.cmake
    INPUT ${CMAKE_CURRENT_BINARY_DIR}/cmake/CTestTestfile.cmake.tmp
  )

endif()
