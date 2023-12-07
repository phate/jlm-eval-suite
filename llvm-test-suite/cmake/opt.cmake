# O3 = --iln --inv --red --dne --ivt --inv --dne --psh --inv --dne
#      --red --cne --dne --pll --inv --dne --url --inv
set(OPTFLAGS "${OPTFLAGS} -JInvariantValueRedirection -JNodeReduction -Jdne -Jivt -JInvariantValueRedirection -Jdne -JInvariantValueRedirection -Jdne -JNodeReduction -Jcne -Jdne -Jpll -JInvariantValueRedirection -Jdne -Jurl -JInvariantValueRedirection")

set(CMAKE_C_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
