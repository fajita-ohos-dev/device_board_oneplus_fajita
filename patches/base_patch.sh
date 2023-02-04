#!/bin/bash
#base patch 复制官方内核驱动到对应目录
set -e

PROJECT_ROOT=$1
KERNEL_VERSION=$2
KERNEL_SRC_TMP_PATH=${PROJECT_ROOT}/out/KERNEL_OBJ/kernel/src_tmp/${KERNEL_VERSION}

cp -rf ${PROJECT_ROOT}/kernel/linux/linux-5.10/drivers/staging/hilog ${KERNEL_SRC_TMP_PATH}/drivers/staging/hilog
cp -rf ${PROJECT_ROOT}/kernel/linux/linux-5.10/drivers/staging/hievent ${KERNEL_SRC_TMP_PATH}/drivers/staging/hievent
sed -i '/endif # STAGING/i source "drivers/staging/hilog/Kconfig"' ${KERNEL_SRC_TMP_PATH}/drivers/staging/Kconfig
sed -i '/endif # STAGING/i\' ${KERNEL_SRC_TMP_PATH}/drivers/staging/Kconfig
sed -i '/endif # STAGING/i source "drivers/staging/hievent/Kconfig"' ${KERNEL_SRC_TMP_PATH}/drivers/staging/Kconfig