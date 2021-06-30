unset PLATFORM
. /cvmfs/sft.cern.ch/lcg/views/setupViews.sh LCG_99 x86_64-centos7-clang10-opt
#. /cvmfs/sft.cern.ch/lcg/releases/clang/10.0.0/x86_64-centos7/setup.sh
export INCLUDE_DIRS="$BASE/include"
export STABILIZER=$(dirname "$BASH_SOURCE")
export PATH="$STABILIZER:$PATH"
export LD_LIBRARY_PATH="$STABILIZER:$LD_LIBRARY_PATH"
