#! /bin/bash
#################################################################
## Arch Installation Script #####################################
#################################################################

echo "TLH's Arch Installer"

# Network #######################################################
read -p 'Are you connected to internet? [y/N]: ' neton
if ! [ $neton = 'y' ] && ! [ $neton = 'Y' ]
then 
    echo "Connect to internet to continue..."
    exit
fi


# Filesystem ###################################################
echo "This script will create and format the partitions as follows:"
echo "/dev/nvme0n1p1 - 512Mib will be mounted as /boot/efi"
echo "/dev/nvme0n1p2 - rest of space will be mounted as /"
read -p 'Continue? [y/N]: ' fsok
if ! [ $fsok = 'y' ] && ! [ $fsok = 'Y' ]
then 
    echo "Edit the script to continue..."
    exit
fi
read -p "Please Enter The Disk Name (run lsblk if unsure) [/dev/sda]: " disk

## Programatically Partition ###################################
echo "label: gpt" >> script.sfdisk
echo "start=        2048, size=     2097152, type=EFh, bootable"  >> script.sfdisk
echo "start=     2099200, size=   974673935, type=83" >> script.sfdisk

sudo sfdisk -d $disk 

EOF

# Format #######################################################
mkfs.ext4 /dev/nvme0n1p2
mkfs.fat -F32 /dev/nvme0n1p2

# Time #########################################################
timedatectl set-ntp true

# Pacman keyring ###############################################
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# Mount ########################################################
mount /dev/sda3 /mnt
mkdir -pv /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mkswap /dev/sda2
swapon /dev/sda2

# Install ######################################################
echo "Starting install.."
echo "Installing Arch Linux, KDE with Konsole and Dolphin and GRUB2 as bootloader" 
pacstrap /mnt base base-devel zsh grml-zsh-config grub os-prober amd-ucode efibootmgr dosfstools freetype2 fuse2 mtools dialog xorg xorg-server xorg-xinit mesa xf86-video-nouveau 

# fstab ########################################################
genfstab -U /mnt >> /mnt/etc/fstab

# Script #######################################################
cp -rfv post-install.sh /mnt/root
chmod a+x /mnt/root/post-install.sh

# Chroot #######################################################
echo "After chrooting into newly installed OS, please run the post-install.sh by executing ./post-install.sh"
echo "Press any key to chroot..."
read tmpvar
arch-chroot /mnt /bin/bash

# Finish #######################################################
zenity --text-info --filename=TEXT --html
echo "Press any key to reboot or Ctrl+C to cancel..."
read tmpvar
reboot
