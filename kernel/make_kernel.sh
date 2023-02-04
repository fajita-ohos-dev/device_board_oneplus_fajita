#!/bin/bash
#HDF驱动需要配置PRODUCT_PATH

set -e

export PROJECT_ROOT=$1
export PRODUCT_PATH=$2
export KERNEL_ARCH=$3
export KERNEL_VERSION=$4
export KERNEL_IMAGE=$5
export DEFCONFIG_FILE=$6
export OUT_PKG_DIR=$7
export KERNEL_SRC_TMP_PATH=${PROJECT_ROOT}/out/KERNEL_OBJ/kernel/src_tmp/${KERNEL_VERSION}
export KERNEL_IMAGE_FILE=${KERNEL_SRC_TMP_PATH}/arch/${KERNEL_ARCH}/boot/${KERNEL_IMAGE}

LINUX_KERNEL_MAKEFILE=${PROJECT_ROOT}/device/board/raspberrypi/rpi4/kernel/make_kernel.mk

# rm -f ${KERNEL_IMAGE_FILE}

make -f ${LINUX_KERNEL_MAKEFILE}

if [ -f ${KERNEL_IMAGE_FILE} ];then
    mkdir -p ${OUT_PKG_DIR}
    cp ${KERNEL_IMAGE_FILE} ${OUT_PKG_DIR}/${KERNEL_IMAGE}
    echo "Image: ${KERNEL_IMAGE_FILE} build success"
else
    echo "Image: ${KERNEL_IMAGE_FILE} build failed!!!"
    exit 1
fi