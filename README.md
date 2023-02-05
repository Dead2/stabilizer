## Stabilizer
*Statistically Rigorous Performance Evaluation

This repo is maintained by Hans Kristian Rosbach
                       aka Dead2 (stabilizer àt circlestorm dót org)

About this fork
---------------

This is a fork of the long-unmaintained Stabilizer by Charlie Curtsinger and Emery D. Berger,
consider visiting the [original repo](https://github.com/ccurtsinger/stabilizer).

This version supports LLVM version 12, although there seem to be some crashes with
SZ_STACK or SZ_CODE enabled. SZ_HEAP and SZ_LINK seem to work fine however.

Changes in this fork compared to the original:
 - Partial LLVM 12 compatibility inherited from other 3rd party forks of Stabilizer.
 - Completely rewritten compiler wrapper, much better compatibility with actual clang
   behavior, and much less likely to require major buildsystem changes.
 - Enabling/disabling features is now done by env variables instead of parameters.
 - Dropped support for GCC/Gfortran since DragonEgg has not been ported to newer LLVM.
 - Removed scripts and configs for running SPEC CPU2006.

Help is wanted for testing and fixing the remaining crashes.
Despite the crashes, this is still useful for enabling heap randomizations.

Currently LLVM version 12 is supported and tested, but it likely also supports
several older versions (maybe without crashes too) and possibly newer versions.
Please provide test feedback, so I can update this text.

I am not an LLVM expert, but it seemed that one of the biggest problems this project
had was that it absolutely required a huge amount of changes to most buildsystems and
would not pass even the most basic compiler tests in CMake or GNU Autoconf.
This likely limited the audience that was able to test and use Stabilizer, resulting
in few people interested in fixing bugs.

About Stabilizer
----------------

Stabilizer is a compiler transformation and runtime library for dynamic memory
layout randomization. Programs built with Stabilizer run with randomly-placed
functions, stack frames, and/or heap objects. Functions and stack frames are moved
repeatedly during execution. A random memory layout eliminates the effect of
layout on performance, and repeated randomization leads to normally-distributed
execution times. This makes it straightforward to use standard statistical tests
for performance evaluation.

A more detailed description of Stabilizer is available in the
[Paper](http://www.cs.umass.edu/~charlie/stabilizer.pdf).

Stabilizer Requirements
-----------------------

Stabilizer requires LLVM version 12, see above comment about other versions.
Stabilizer runs on OSX and Linux, and supports x86, x86_64, and PowerPC.

The build system assumes LLVM include files will be accessible through
your default include path.

`szcc`, the compiler wrapper, is written in Python and requires Python3

Building Stabilizer
-------------------

```
$ git clone https://github.com/Dead2/stabilizer.git
$ git submodule update --init --recursive
$ make
```

By default, Stabilizer is built with debug output enabled. Run
`make clean release` to build the release version with asserts and debug output
disabled.

Using Stabilizer
----------------

Stabilizer includes the `szcc` and `szcc++` compiler wrapper, which builds programs
using the Stabilizer compiler transformations. `szcc` passes on common clang flags,
and is compatible with C and C++ inputs.

To manually compile a program in `foo.c` with Stabilizer, run:
```
export SZ_CODE=1 SZ_HEAP=1 SZ_STACK=1 SZ_LINK=1
$ szcc foo.c -o foo
```
The exported env flags enable the various randomizations, and may be used in any
combination.

* `SZ_CODE` Move functions repeatedly during execution.
* `SZ_HEAP` Randomize stack location.
* `SZ_STACK` Move stack repeatedly during execution.
* `SZ_LINK` Randomly reorder linking (only once, during compilation)
* `SZ_VERBOSE` Turns on verbose debugging output from `szcc` during compile.


Letting szcc impersonate Clang
------------------------------

`szcc` can also be run by using `clang` and `clang++` symlinks if the stabilizer
dir is added to PATH. You can also specify compilers manually.

Path:
```
export PATH=/path/to/stabilizer/:$PATH
./configure
```

Manually with CMake:
```
cmake . -DCMAKE_C_COMPILER=/path/to/stabilizer/clang -DCMAKE_CXX_COMPILER=/path/to/stabilizer/clang++
```

Manually with GNU Autoconf:
```
CC=/path/to/stabilizer/clang CXX=/path/to/stabilizer/clang++ ./configure
```

The resulting executable is linked against `libstabilizer.so` (or `.dylib` on OSX).
Place this library somewhere in your system's dynamic library search path or
add the Stabilizer base directory to your `LD_LIBRARY_PATH` or `DYLD_LIBRARY_PATH`
environment variable to allow running the compiled programs.

Credits
-------

Original code by
[Charlie Curtsinger](http://www.cs.umass.edu/~charlie) and [Emery D. Berger](http://www.cs.umass.edu/~emery)

Copyright (C) 2013 University of Massachusetts Amherst

License
-------

Stabilizer is distributed under the GNU GPLv2 license.
Contact <charlie@cs.umass.edu> if you are interested in
licensing Stabilizer for commercial use.
