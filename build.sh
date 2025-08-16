#!/bin/bash

export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
export PATH="/home/nikonekoqwq/nikokernel_5.15/prebuilts/clang/host/linux-x86/clang-r563880/bin:$PATH"
export KBUILD_BUILD_VERSION="0"
export SOURCE_DATE_EPOCH=$(date +%s)
a7zip="${PWD}/7zzs"

build_date=$(date +%y%m%d)


workdir=$(cd "$(dirname "$0")"; pwd)
# 切换到脚本所在目录
cd "$workdir"
# 在这里执行需要在脚本根目录下执行的命令
echo "当前工作目录：$(pwd)"
a7zip="$workdir/7zzs"
source "$workdir/function.sh"
build_date=$(date +%y%m%d)
Image_out_dir="$workdir/out/arch/arm64/boot/"
sudo rm -rf "$workdir/out/*"

yellow "开始构建内核"


make LLVM=1 LLVM_IAS=1 ARCH=arm64 CC="clang" BUILD_CONFIG=build.config.gki.aarch64 O=out DEPMOD=depmod star_defconfig && \
scripts/config --file out/.config -e LTO_CLANG -d LTO_NONE -e LTO_CLANG_THIN -d LTO_CLANG_FULL -e THINLTO && \
make -j24 O=out ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1


cp "$Image_out_dir/Image" "$workdir/Image"
sudo chmod -R +x "$workdir/7zzs"
cp -r ${PWD}/anykernel3/ ${PWD}/out_ak3
cp "$workdir/Image" ${PWD}/out_ak3/anykernel3
$a7zip a ${PWD}/out_ak3/NikoKernel_11PU_5.4Kernel_ak3_test.zip ${PWD}/out_ak3/anykernel3/*




