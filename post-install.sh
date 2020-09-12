#! /bin/bash

# This script runs within the chroot after being copied over by the last one. It is intended to create the baseline from which I can then reboot and download my dotfiles with corresponding installation scripts

echo "TLH's Preliminary Arch Configurator"

# Set date time
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname
read -p "Enter your desired hostname: " host
echo $host >> /etc/hostname
echo "127.0.1.1 $host.localdomain  $host" >> /etc/hosts

# Generate initramfs
mkinitcpio -P

# Set root password
passwd

# Install bootloader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

# Create new user
useradd -m -G wheel,power,iput,storage,uucp,network -s /usr/bin/zsh tlh
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
echo "Set password for new user tlh"
passwd tlh

# Setup display manager
systemctl enable lightdm.service

# Enable services
systemctl enable NetworkManager.service

echo "Configuration done. You can exiting chroot."
wait 15
