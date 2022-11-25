#!/bin/env bash

set -euo pipefail

your_host='arch-dwm'

ln -sf /usr/share/zoneinfo/Chicago/America /etc/localtime       # Create symbolic links for timezone
hwclock --systohc                                               # Sync system clock with hardware clock
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8' /etc/locale.gen # Uncomment en_US.UTF-8 UTF-8 in /etc/locale.gen
locale-gen                                                      # Generate locales
echo "LANG=en_US.UTF-8" >>/etc/locale.conf                      # Set LANG=en_US.UTF-8 in /etc/locale.conf
echo "KEYMAP=us" >>/etc/vconsole.conf                           # Set KEYMAP=us in /etc/vconsole.conf
echo "${your_host}" >>/etc/hostname                             # Set hostname in /etc/hostname
# set hosts
{
    echo "127.0.0.1 localhost"
    echo "::1       localhost"
    echo "127.0.1.1 ${your_host}.localdomain ${your_host}"
} >/etc/hosts

echo root:password | chpasswd

pacman -Syy - <final.paclist.txt

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable acpid
systemctl enable avahi-daemon
systemctl enable bluetooth
systemctl enable cronie.service
systemctl enable cups.service
systemctl enable docker.service
systemctl enable firewalld
systemctl enable libvirtd
systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable sshd

useradd -m sam
echo sam:password | chpasswd
usermod -aG sys,log,libvirt,docker,lp,network,power,rfkill,users,video,storage,audio,wheel,/bin/zsh sam
systemctl enable --user mpd.service
