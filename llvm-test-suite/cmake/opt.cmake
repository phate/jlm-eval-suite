# O3 = --iln --inv --red --dne --ivt --inv --dne --psh --inv --dne
#      --red --cne --dne --pll --inv --dne --url --inv
set(OPTFLAGS "${OPTFLAGS} -Jinv -Jdne -Jivt -Jinv -Jdne -Jinv -Jdne -Jcne -Jdne -Jpll -Jinv -Jdne -Jurl -Jinv")

set(CMAKE_C_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
