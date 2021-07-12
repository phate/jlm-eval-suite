set(OPTFLAGS "${OPTFLAGS} -Jinv -Jdne -Jivt -Jinv -Jdne -Jinv -Jdne -Jpll -Jinv -Jdne -Jurl -Jinv")

set(CMAKE_C_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${OPTFLAGS}" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
