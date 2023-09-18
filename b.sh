#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export ARCH=arm64
export KBUILD_BUILD_HOST="nobody"
export KBUILD_BUILD_USER="fjrXTR"
git clone --depth=1 https://github.com/kdrag0n/proton-clang "${HOME}/clang-proton"

rm -rf AnyKernel
make O=out ARCH=arm64 rosemary_defconfig

PATH="${HOME}/clang-proton/bin:${PATH}" \
make -j20 O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      CONFIG_SECTION_MISMATCH_WARN_ONLY=y
}
function zupload()
{
git clone --depth=1 https://github.com/fjrXTR/AnyKernel3.git -b master AnyKernel
cp out/arch/arm64/boot/Image.gz AnyKernel
cd AnyKernel
zip -r9 sphinXkernel-fern!-rosemary-v1.0-svendor.zip *
curl -T sphinXkernel-fern!-rosemary-v1.0-svendor.zip oshi.at
}

compile
zupload