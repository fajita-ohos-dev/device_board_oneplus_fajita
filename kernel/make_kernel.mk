
# ohos makefile to build kernel

KERNEL_CONFIG_PATH = $(PROJECT_ROOT)/device/board/oneplus/fajita/kernel/configs
export INSTALL_MOD_PATH := $(PROJECT_ROOT)/device/board/oneplus/fajita/modules
PREBUILTS_GCC_DIR := $(PROJECT_ROOT)/prebuilts/gcc
PREBUILTS_CLANG_DIR := $(PROJECT_ROOT)/prebuilts/clang
CLANG_HOST_TOOLCHAIN := $(PROJECT_ROOT)/prebuilts/clang/ohos/linux-x86_64/llvm/bin
KERNEL_HOSTCC := $(CLANG_HOST_TOOLCHAIN)/clang
CLANG_CC := $(CLANG_HOST_TOOLCHAIN)/clang

KERNEL_PREBUILT_MAKE := make

ifeq ($(KERNEL_ARCH), arm)
    KERNEL_TARGET_TOOLCHAIN := $(PREBUILTS_GCC_DIR)/linux-x86/arm/gcc-linaro-7.5.0-arm-linux-gnueabi/bin
    KERNEL_TARGET_TOOLCHAIN_PREFIX := $(KERNEL_TARGET_TOOLCHAIN)/arm-linux-gnueabi-
    DTBS := sdm845-rpi-4-b.dtb overlays/vc4-fkms-v3d.dtbo overlays/rpi-ft5406.dtbo overlays/rpi-backlight.dtbo overlays/dwc2.dtbo
else ifeq ($(KERNEL_ARCH), arm64)
    KERNEL_TARGET_TOOLCHAIN := $(PREBUILTS_GCC_DIR)/linux-x86/aarch64/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin
    KERNEL_TARGET_TOOLCHAIN_PREFIX := $(KERNEL_TARGET_TOOLCHAIN)/aarch64-linux-gnu-
    DTBS := qualcomm/sdm845-rpi-4-b.dtb overlays/vc4-fkms-v3d.dtbo overlays/rpi-ft5406.dtbo overlays/rpi-backlight.dtbo overlays/dwc2.dtbo
endif

KERNEL_PERL := /usr/bin/perl

KERNEL_CROSS_COMPILE :=
KERNEL_CROSS_COMPILE += CC="$(CLANG_CC)"
KERNEL_CROSS_COMPILE += HOSTCC="$(KERNEL_HOSTCC)"
KERNEL_CROSS_COMPILE += PERL=$(KERNEL_PERL)
KERNEL_CROSS_COMPILE += CROSS_COMPILE="$(KERNEL_TARGET_TOOLCHAIN_PREFIX)"

KERNEL_MAKE := \
    $(KERNEL_PREBUILT_MAKE)

$(KERNEL_IMAGE_FILE):
	echo "build kernel..."
	cp -rf $(KERNEL_CONFIG_PATH)/$(DEFCONFIG_FILE) $(KERNEL_SRC_TMP_PATH)/arch/$(KERNEL_ARCH)/configs
	$(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) distclean
	$(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(DEFCONFIG_FILE)
	$(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) modules_prepare
	$(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) -j12 $(KERNEL_IMAGE)
	$(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(DTBS)
#	$(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) modules modules_install
.PHONY: build-kernel
build-kernel: $(KERNEL_IMAGE_FILE)
