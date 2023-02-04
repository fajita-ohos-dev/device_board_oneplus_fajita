#!/bin/bash
set -e

PROJECT_ROOT=$1
KERNEL_VERSION=$2
OUT_DIR=${PROJECT_ROOT}/out/KERNEL_OBJ
KERNEL_SRC_PATH=${PROJECT_ROOT}/kernel/linux/${KERNEL_VERSION}
KERNEL_SRC_TMP_PATH=${OUT_DIR}/kernel/src_tmp/${KERNEL_VERSION}
PATCHES_PATH=${PROJECT_ROOT}/device/board/raspberrypi/rpi4/patches
HDF_PATCH_FILE=${PATCHES_PATH}/hdf.patch
KERNEL_PATCH=${PATCHES_PATH}/rpi4.patch

if [ ! -d "${KERNEL_SRC_TMP_PATH}" ];then
    mkdir -p ${KERNEL_SRC_TMP_PATH}
    cp -arfL ${KERNEL_SRC_PATH}/* ${KERNEL_SRC_TMP_PATH}/

    cd ${KERNEL_SRC_TMP_PATH}

    #hdf patch 打入HDF补丁
    bash ${PATCHES_PATH}/hdf_patch.sh ${PROJECT_ROOT} ${KERNEL_SRC_TMP_PATH} ${HDF_PATCH_FILE}

    #kernel patch
    patch -p1 < ${KERNEL_PATCH}
fi

if [ -d "${KERNEL_SRC_TMP_PATH}" ];then
    echo "kernel tmp src is ready"
else
    echo "kernel tmp src not ready!!!"
    exit 1
fi
