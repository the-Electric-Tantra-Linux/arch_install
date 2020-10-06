# README
## arch_install

Basically this is a script, based on Krushn's Arch Installation Script, that takes you from the ISO file to an installed arch linux system because I grew tired of <kbd>CRTL</kbd> + <kbd>Alt</kbd> + <kbd> 2 </kbd> and trying to remember the order perfectly flipping between virtual terminals. 

> Advice: If you haven't ever installed Arch manually, this is just a bandaid and if I haven't updated the thing for some new change to that system (like happened recently where they stopped including the default terminal in pacstrap) then you will be stuck if you don't know how to manually install it, so force yourself to learn it first.

> Alternative: Use any other distribution with a decent installer. Manjaro's Architect is really plush.



## Contents 

Script 1: Everything before the arch-chroot command

Script 2: Everything within the chroot 


## Using the Script
> NOTICE: you must adjust the script to the disk you intend to install on, I am not responsible for you not doing so and destroying some vital information *you should have backed up anyway*. 


At the prompt that comes up when you boot from ISO run the following:

```bash

pacman -Sy --noconfirm git vim


git clone https://github.com/Thomashighbaugh/arch_install 


cd arch_install 


# Adjust install script for your disk setup 

# run: lsblk 
# to check for disks on your system

vim install.sh  

./install.sh 

# Will drop you into chroot where the install occurred 

./root/post-install.sh

exit 

reboot


```
And then you are done installing Arch Linux without any of the hassle other than one modification to a vim line.

## Things You Will Still Need To Do After 

1. reboot - obviously
2. create a new user - doesn't stick when you do it before the reboot for some reason so save the time and wait until root, then 
`useradd -s /bin/zsh -g wheel -m {USER_NAME_HERE}` 
3. install your choice of WM or DE. I use my dotfiles for this but this is modular enough it can be used independently of my dotfiles, and pulling that whole repo for these two scripts makes little sense so lucky you!

### System State Post-Install

When you then boot into arch linux for the first time, if you don't modify the pacstrap command in `install.sh` and change `post-install.sh` to include a systemd command to start your Display Manager at boot, you will boot to a console. For me this is intended, I have my dotfiles that will install all of that and take care of all of that hassle and I am comfortable on console to the point where the DEs sound like more of a headache so I have left them out. 

If you wanted to run this script alone and have a fully installed Arch Linux syustem complete with a standard DE, add the package name in `install.sh` on the line that starts with `pacstrap` and then in `post-install.sh` add a line towards the end like the following but adjusted for your DM ``systemctl enable lightdm`` and uncomment the user creation portion of that script (using the name you want for your user). If there is no user on boot, which is true of trying this at the time of writing, you will have to create a user later. Sorry not my fault, its upstream and I don't really care enough to mitigate it but pull requests are always welcome. 
