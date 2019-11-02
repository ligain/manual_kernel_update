#!/bin/bash

# Install Development Tools
yum groupinstall "Development Tools" -y
yum install wget bc openssl-devel ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel -y

# Download and unpack kernel
cd /usr/src
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.8.tar.xz
tar -Jxvf linux-5.3.8.tar.xz
cd linux-5.3.8/

# Generate kernel config
cp -v /boot/config-$(uname -r) .config
make olddefconfig
scripts/config --module CONFIG_DRM_VBOXVIDEO --enable CONFIG_VBOXGUEST --enable CONFIG_VIRT_DRIVERS --module DRM --module DRM_KMS_HELPER --module DRM_VRAM_HELPER --enable GENERIC_ALLOCATOR

# Build kernel
make -j $(nproc)
make modules_install -j $(nproc)
make install -j $(nproc)

# Update GRUB config
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0

shutdown -r now