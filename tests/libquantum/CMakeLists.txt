add_executable(libquantum)

target_compile_definitions(libquantum
  PRIVATE
    SPEC_CPU
    SPEC_CPU_LINUX
)

target_link_libraries(libquantum
  m
)

target_sources(libquantum
  PRIVATE
    classic.c
    classic.h
    complex.c
    config.h
    decoherence.c
    decoherence.h
    defs.h
    expn.c
    gates.c
    gates.h
    lq_complex.h
    matrix.c
    matrix.h
    measure.c
    measure.h
    oaddn.c
    oaddn.h
    objcode.c
    objcode.h
    omuln.c
    omuln.h
    qec.c
    qec.h
    qft.c
    quantum.h
    qureg.c
    qureg.h
    shor.c
    specrand.c
    specrand.h
    version.c
)

add_test(
  NAME libquantum
  COMMAND libquantum 128
)
