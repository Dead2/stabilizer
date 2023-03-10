cmake_minimum_required(VERSION 3.21)
# 3.21 - CMAKE_<LANG>_LINKER_LAUNCHER

project(stabilizer CXX)

option(BUILD_TESTING "Build the testing project." ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(GNUInstallDirs)

add_subdirectory(pass)
add_subdirectory(runtime)

install(
  PROGRAMS szcc szcc++
  TYPE BIN
)

install(
  FILES LICENSE
  TYPE DOC
)

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
    StabilizerToolchain.cmake.in
    StabilizerToolchain.cmake.in
    @ONLY
  )
  file(GENERATE
    OUTPUT StabilizerToolchain.cmake
    INPUT ${CMAKE_CURRENT_BINARY_DIR}/StabilizerToolchain.cmake.in
  )

  # Add tests project
  include(ExternalProject)
  ExternalProject_Add(
    tests
    DEPENDS LLVMStabilizer stabilizer
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/tests
    CMAKE_ARGS
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/StabilizerToolchain.cmake
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ""
  )

  # CRAP: workaround for launching tests from the root dir
  # https://discourse.cmake.org/t/testing-in-a-superbuild/1906
  ExternalProject_Get_Property(tests BINARY_DIR)
  file(RELATIVE_PATH ctest_dir "${CMAKE_CURRENT_BINARY_DIR}" "${BINARY_DIR}")
  configure_file(
    CTestTestfile.cmake.in
    CTestTestfile.cmake.in
  )
  file(GENERATE
    OUTPUT CTestTestfile.cmake
    INPUT ${CMAKE_CURRENT_BINARY_DIR}/CTestTestfile.cmake.in
  )

endif()
