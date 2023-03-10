add_library(LLVMStabilizer MODULE)

# CRAP: we don't need C language, but `find_package(LLVM)` forces the check
enable_language(C)

find_package(LLVM ${STABILIZER_LLVM_VERSION} REQUIRED CONFIG)

target_include_directories(LLVMStabilizer PRIVATE ${LLVM_INCLUDE_DIRS})

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
target_compile_definitions(LLVMStabilizer PRIVATE ${LLVM_DEFINITIONS_LIST})

target_sources(LLVMStabilizer
  PRIVATE
    IntrinsicLibcalls.h
    LowerIntrinsics.cpp
    Stabilizer.cpp
)

install(
  TARGETS LLVMStabilizer
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
