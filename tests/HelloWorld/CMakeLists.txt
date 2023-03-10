add_executable(hello)

target_sources(hello
  PRIVATE
    hello.cpp
)

add_test(
  NAME hello
  COMMAND hello
)
