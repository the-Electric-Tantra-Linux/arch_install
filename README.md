# README
## arch_install

Basically this is a script, based on Krushn's Arch Installation Script, that takes you from the ISO file to an installed arch linux system because I grew tired of <kbd>CRTL</kbd> + <kbd>Alt</kbd> + <kbd> 2 </kbd> and trying to remember the order perfectly flipping between virtual terminals. 

> Advice: If you haven't ever installed Arch manually, this is just a bandaid and if I haven't updated the thing for some new change to that system (like happened recently where they stopped including the default terminal in pacstrap) then you will be stuck if you don't know how to manually install it, so force yourself to learn it first.

> Alternative: Use any other distribution with a decent installer. Manjaro's Architect is really plush.



## Contents 

Script 1: Everything before the arch-chroot command

Script 2: Everything within the chroot 


## Using the Script
At the prompt that comes up when you boot from ISO run the following:

```bash
pacman -Sy git 

git clone https://github.com/Thomashighbaugh/arch_install 

cd arch_install 

./install.sh 

```

### Unless
unless you are using another disk than /dev/sda as your root. On my workstation this is true of me as well, using /dev/nvme0n1p2 as my root generally, but until I have to reinstall the OS on it I am not going to modify the script to hold a variable that accepts your input as the disk, sorry. 



## Things You Will Still Need To Do After 

1. reboot - obviously
2. create a new user - doesn't stick when you do it before the reboot for some reason so save the time and wait until root, then 
`useradd -s /bin/zsh -g wheel -m tlh` 
3. install your choice of WM or DE. I use my dotfiles for this but this is modular enough it can be used independently of my dotfiles, and pulling that whole repo for these two scripts makes little sense so lucky you!