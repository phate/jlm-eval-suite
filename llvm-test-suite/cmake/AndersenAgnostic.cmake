set(OPTFLAGS "${OPTFLAGS} -JAAAndersenAgnostic")
# set(OPTFLAGS "${OPTFLAGS} -JInvariantValueRedirection -JNodeReduction -JDeadNodeElimination -JThetaGammaInversion -JInvariantValueRedirection -JDeadNodeElimination -JInvariantValueRedirection -JDeadNodeElimination -JNodeReduction -JCommonNodeElimination -JDeadNodeElimination -JNodePullIn -JInvariantValueRedirection -JDeadNodeElimination -JLoopUnrolling -JInvariantValueRedirection")

set(JLC_WITH_ANDERSEN_AGNOSTIC "YES" CACHE STRING "Disable tests that do not work with AndersenAgnostic")
set(CMAKE_C_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
