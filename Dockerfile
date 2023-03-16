FROM docker.io/ubuntu:22.04 AS base

RUN apt-get update && apt-get upgrade -y

ARG LLVM_VERSION

RUN apt-get install -y --no-install-recommends \
    clang-$LLVM_VERSION llvm-$LLVM_VERSION-dev python3

ENV PATH="/usr/lib/llvm-$LLVM_VERSION/bin:$PATH"


FROM base AS builder

RUN apt-get install -y --no-install-recommends cmake make

WORKDIR /stabilizer
COPY . .

RUN cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang-$LLVM_VERSION \
    -DCMAKE_CXX_COMPILER=clang++-$LLVM_VERSION \
    -DBUILD_TESTING=OFF \
    -DSTABILIZER_LLVM_VERSION=$(llvm-configure-$LLVM_VERSION --version)

RUN cmake --build build
RUN cmake --install build
RUN ldconfig /usr/local/lib


FROM base
COPY --from=builder /usr/local /usr/local
RUN ldconfig /usr/local/lib
