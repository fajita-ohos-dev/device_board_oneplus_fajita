固件生成说明

1. 执行全量编译
./build.sh --product-name rpi4 --ccache

2. 合并镜像
方法1：全量编译后再执行合并生成烧录固件
./build.sh --product-name rpi4 --build-target firmware

方法2：复制image下的ptgen和make_rpi_sdcard_image.py到out/rpi4/packages/phone/images目录
执行脚本
python make_rpi_sdcard_image.py --output firmware.img --userdata 1000M boot.img system.img vendor.img userdata.img