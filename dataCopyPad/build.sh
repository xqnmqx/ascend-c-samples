rm -rf ./build
mkdir -p build
cd build
# 配置和编译
cmake .. ${cmake_args}
make -j VERBOSE=1
