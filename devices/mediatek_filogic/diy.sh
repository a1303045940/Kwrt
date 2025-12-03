#!/bin/bash

shopt -s extglob
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

#bash $SHELL_FOLDER/../common/kernel_6.6.sh

# 方法1：修改 target Makefile（推荐）
sed -i 's/KERNEL_PATCHVER:=6.6.117/KERNEL_PATCHVER:=6.6.116/g' target/linux/mediatek/filogic/Makefile || true
sed -i 's/KERNEL_PATCHVER:=6.6.117/KERNEL_PATCHVER:=6.6.116/g' target/linux/mediatek/Makefile || true

# 方法2：如果上面没找到，强制替换所有 6.6.117 为 6.6.116
find target/linux/mediatek -type f -name "Makefile" -exec sed -i 's/6.6.117/6.6.116/g' {} \; || true

# 验证修改
echo "内核版本文件修改结果："
grep -l "6.6.116" target/linux/mediatek/*/Makefile 2>/dev/null || echo "未找到 6.6.116 定义，可能需要手动补充"



sed -i -E -e 's/ ?root=\/dev\/fit0 rootwait//' -e "/rootdisk =/d" -e '/bootargs.* = ""/d' target/linux/mediatek/dts/*{qihoo-360t7,netcore-n60,h3c-magic-nx30-pro,jdcloud-re-cp-03,cmcc-rax3000m,jcg-q30-pro,tplink-tl-xdr*}.dts

find target/linux/mediatek/filogic/base-files/ -type f -exec sed -i "s/-stock//g" {} \;
find target/linux/mediatek/base-files/ -type f -exec sed -i "s/-stock//g" {} \;

sed -i "s/-stock//g" package/boot/uboot-envtools/files/mediatek_filogic

sed -i "s/openwrt-mediatek-filogic/kwrt-mediatek-filogic/g" target/linux/mediatek/image/filogic.mk
sed -i "s/ fitblk / /g" target/linux/mediatek/image/filogic.mk

# 禁用小容量设备
# echo "🔧 禁用小容量设备..."
# if [ -f ".config" ]; then
#   sed -i 's/CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_cudy_re3000-v1=y/# CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_cudy_re3000-v1 is not set/' .config
#   sed -i 's/CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_cudy_wr3000-v1=y/# CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_cudy_wr3000-v1 is not set/' .config
#   sed -i 's/CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_netgear_wax220=y/# CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_netgear_wax220 is not set/' .config
#   echo "✅ 配置修改完成"
# else
#   echo "⚠️ .config 文件不存在，跳过设备禁用"
# fi

# echo "✅ 所有修改完成"
