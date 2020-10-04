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
# to create the partitions programatically (rather than manually)
# https://superuser.com/a/984637
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Format #######################################################
mkfs.ext4 /dev/nvme0n1p2
mkfs.fat -F32 /dev/nvme0n1p1

# Time #########################################################
timedatectl set-ntp true

# Pacman keyring ###############################################
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# Mount ########################################################
mount /dev/sda2 /mnt
mkdir -pv /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Install ######################################################
echo "Starting install.."
echo "Installing Arch Linux"
pacstrap /mnt linux-headers linux linux-firmware base base-devel zsh grub os-prober amd-ucode efibootmgr dosfstools freetype2 fuse2 mtools dialog xorg xorg-server xorg-xinit mesa  

# fstab ########################################################
genfstab -U /mnt >> /mnt/etc/fstab

# Script #######################################################
cp -rfv post-install.sh /mnt/root
chmod a+x /mnt/root/post-install.sh

# Chroot #######################################################
echo "After chrooting into newly installed OS, please run the post-install.sh by executing ./post-install.sh"
echo "Press any key to chroot..."
arch-chroot /mnt /bin/bash

# Finish #######################################################
echo "Please reboot immeadiately..."
reboot
