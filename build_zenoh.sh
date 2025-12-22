#!/bin/bash

VERSION=1.7.1

ZENOHC_DIR=zenoh-c-${VERSION}
ZENOHC_BUILD_DIR=${ZENOHC_DIR}-build

wget https://github.com/eclipse-zenoh/zenoh-c/archive/${VERSION}.tar.gz -O zenoh-c.tar.gz
tar -xvf zenoh-c.tar.gz

cmake \
  -S ${ZENOHC_DIR} \
  -B ${ZENOHC_BUILD_DIR} \
  -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX=${PWD} \
  -DZENOHC_INSTALL_STATIC_LIBRARY=TRUE \
  -DZENOHC_CARGO_CHANNEL=+stable \
  -DZENOHC_BUILD_WITH_SHARED_MEMORY=TRUE \
  -DZENOHC_BUILD_WITH_UNSTABLE_API=TRUE \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF \
  -DCMAKE_TOOLCHAIN_FILE=${PWD}/toolchain_clang.cmake
cmake --build ${ZENOHC_BUILD_DIR}
cmake --install ${ZENOHC_BUILD_DIR}

ZENOHCPP_VERSION=${VERSION}
ZENOHCPP_DIR=zenoh-cpp-${ZENOHCPP_VERSION}
ZENOHCPP_BUILD_DIR=${ZENOHCPP_DIR}-build

wget https://github.com/eclipse-zenoh/zenoh-cpp/archive/${ZENOHCPP_VERSION}.tar.gz -O zenoh-cpp.tar.gz
tar -xvf zenoh-cpp.tar.gz

cmake . \
  -S ${ZENOHCPP_DIR} \
  -B ${ZENOHCPP_BUILD_DIR} \
  -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX=${PWD} \
  -Dzenohc_DIR=../install/lib/cmake/zenohc \
  -DZ_FEATURE_UNSTABLE_API=1 \
  -DZENOHCXX_EXAMPLES_PROTOBUF=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF \
  -DCMAKE_TOOLCHAIN_FILE=${PWD}/toolchain_clang.cmake
cmake --build ${ZENOHCPP_BUILD_DIR}
cmake --install ${ZENOHCPP_BUILD_DIR}
