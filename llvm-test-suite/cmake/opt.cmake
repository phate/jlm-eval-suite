# O3 = --iln --inv --red --dne --ivt --inv --dne --psh --inv --dne
#      --red --cne --dne --pll --inv --dne --url --inv
set(OPTFLAGS "${OPTFLAGS} -JInvariantValueRedirection -JNodeReduction -JDeadNodeElimination -JThetaGammaInversion -JInvariantValueRedirection -JDeadNodeElimination -JInvariantValueRedirection -JDeadNodeElimination -JNodeReduction -JCommonNodeElimination -JDeadNodeElimination -JNodePullIn -JInvariantValueRedirection -JDeadNodeElimination -JLoopUnrolling -JInvariantValueRedirection")

set(CMAKE_C_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
