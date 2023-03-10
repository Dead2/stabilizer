add_executable(bzip2)

target_compile_definitions(bzip2
  PRIVATE
    SPEC_CPU
    SPEC_CPU_LINUX_X64
)

target_sources(bzip2
  PRIVATE
    blocksort.c
    bzip2.c
    bzlib.c
    bzlib.h
    bzlib_private.h
    compress.c
    crctable.c
    decompress.c
    huffman.c
    randtable.c
    spec.c
    spec.h
)

add_test(
  NAME bzip2
  COMMAND bzip2 ${CMAKE_CURRENT_SOURCE_DIR}/input.combined
)
