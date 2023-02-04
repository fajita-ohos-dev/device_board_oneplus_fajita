#!/bin/bash
#HDF驱动需要配置PRODUCT_PATH

set -e

PROJECT_ROOT=/home/diemit/OpenHarmony
PRODUCT_PATH=vendor/oneplus/fajita
KERNEL_ARCH=arm
KERNEL_VERSION=linux-5.10
KERNEL_IMAGE=zImage
DEFCONFIG_FILE=sdm845_oh_32_defconfig
OUT_PKG_DIR=${PROJECT_ROOT}/out/fajita/packages/phone/images

OUT_DIR=${PROJECT_ROOT}/out/KERNEL_OBJ
KERNEL_SRC_TMP_PATH=${OUT_DIR}/kernel/src_tmp/${KERNEL_VERSION}
KERNEL_IMAGE_FILE=${KERNEL_SRC_TMP_PATH}/arch/${KERNEL_ARCH}/boot/${KERNEL_IMAGE}

bash check_patch.sh ${PROJECT_ROOT} ${KERNEL_VERSION}
bash make_kernel.sh ${PROJECT_ROOT} ${PRODUCT_PATH} ${KERNEL_ARCH} ${KERNEL_VERSION} ${KERNEL_IMAGE} ${DEFCONFIG_FILE} ${OUT_PKG_DIR}
