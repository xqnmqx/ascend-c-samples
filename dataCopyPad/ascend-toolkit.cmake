if(NOT LINUX)
    message(FATAL_ERROR "This project requires Linux")
endif()

if (DEFINED ENV{ASCEND_TOOLKIT_HOME})
    message(STATUS "ASCEND_TOOLKIT_HOME is set to: $ENV{ASCEND_TOOLKIT_HOME}")
else()
    message(FATAL_ERROR "ASCEND_TOOLKIT_HOME is not set. Please set it before running CMake.")
endif()

if (NOT DEFINED ENV{ASCEND_HOME_PATH})
    set(ENV{ASCEND_HOME_PATH} $ENV{ASCEND_TOOLKIT_HOME})
endif()

if (NOT DEFINED CMAKE_C_COMPILER)
    set(CMAKE_C_COMPILER "$ENV{ASCEND_TOOLKIT_HOME}/bin/ccec")
endif()
if (NOT DEFINED CMAKE_CXX_COMPILER)
    set(CMAKE_CXX_COMPILER "${CMAKE_C_COMPILER}")
endif()

if (NOT DEFINED CMAKE_PREFIX_PATH)
    set(CMAKE_PREFIX_PATH "$ENV{ASCEND_TOOLKIT_HOME}/lib64/cmake")
endif()

find_package(ASC REQUIRED)
