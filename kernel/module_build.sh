#!/bin/bash
set -e

export PROJECT_ROOT=/home/diemit/OpenHarmony
export PRODUCT_PATH=vendor/rpifdn/rpi4
export ARCH=arm64
export KERNEL_VERSION=linux-rpi-5.10
export CC=${PROJECT_ROOT}/prebuilts/clang/ohos/linux-x86_64/llvm/bin/clang
export HOSTCC=${PROJECT_ROOT}/prebuilts/clang/ohos/linux-x86_64/llvm/bin/clang
export CROSS_COMPILE=${PROJECT_ROOT}/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export OUT_DIR=${PROJECT_ROOT}/out/KERNEL_OBJ
export KERNEL_SRC_TMP_PATH=${OUT_DIR}/kernel/src_tmp/${KERNEL_VERSION}
export INSTALL_MOD_PATH=${PROJECT_ROOT}/device/rpifdn/modules

make -C ${KERNEL_SRC_TMP_PATH} modules_prepare modules modules_install
