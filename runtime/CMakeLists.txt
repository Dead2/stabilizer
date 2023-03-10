add_library(stabilizer MODULE)

target_include_directories(stabilizer
  PRIVATE
    ${CMAKE_SOURCE_DIR}/Heap-Layers
    ${CMAKE_SOURCE_DIR}/DieHard/src/include
    ${CMAKE_SOURCE_DIR}/DieHard/src/include/math
    ${CMAKE_SOURCE_DIR}/DieHard/src/include/rng
    ${CMAKE_SOURCE_DIR}/DieHard/src/include/static
    ${CMAKE_SOURCE_DIR}/DieHard/src/include/util
)

target_sources(stabilizer
  PRIVATE
    Arch.h
    Context.h
    Debug.cpp
    Debug.h
    Function.cpp
    Function.h
    FunctionLocation.h
    Heap.cpp
    Heap.h
    Intrinsics.cpp
    Jump.h
    MMapSource.h
    MemRange.h
    Trap.h
    Util.h
    libstabilizer.cpp
)

install(
  TARGETS stabilizer
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
