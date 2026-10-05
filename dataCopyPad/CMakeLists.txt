cmake_minimum_required(VERSION 3.24)

include(./ascend-toolkit.cmake)

project(unary_op_datacopypad_neg LANGUAGES C)

set(CCE_AICORE_ARCH "dav-c220-vec")

set_source_files_properties(main.cce PROPERTIES LANGUAGE C)

add_executable(unary_op_datacopypad_neg main.cce)

target_include_directories(unary_op_datacopypad_neg PUBLIC
    $ENV{ASCEND_TOOLKIT_HOME}/compiler/tikcpp/tikcfw
    $ENV{ASCEND_TOOLKIT_HOME}/compiler/tikcpp/tikcfw/impl
    $ENV{ASCEND_TOOLKIT_HOME}/compiler/tikcpp/tikcfw/interface
    $ENV{ASCEND_TOOLKIT_HOME}/include
    $ENV{ASCEND_INSTALL_PATH}/compiler/tikcpp/ascendc_kernel_cmake
)

target_compile_options(unary_op_datacopypad_neg PRIVATE
    -xcce
    -std=c++17
    --cce-aicore-arch=${CCE_AICORE_ARCH}
)

target_link_options(unary_op_datacopypad_neg PUBLIC
    "-L$ENV{ASCEND_TOOLKIT_HOME}/devlib/"
    "-L$ENV{ASCEND_TOOLKIT_HOME}/lib64/"
    --cce-aicore-arch=${CCE_AICORE_ARCH}
    --cce-fatobj-link
)

target_link_libraries(unary_op_datacopypad_neg PUBLIC
    stdc++
    acl_rt
    runtime
    tiling_api
    register
    platform
    m
)

set_target_properties(unary_op_datacopypad_neg PROPERTIES
    BUILD_WITH_INSTALL_RPATH TRUE
    INSTALL_RPATH_USE_LINK_PATH FALSE
    INSTALL_RPATH "$ENV{ASCEND_TOOLKIT_HOME}/lib64/"
)
