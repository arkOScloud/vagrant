#!/usr/bin/env bash

# Set initial options
echo "arkos" > /etc/hostname
localectl set-locale "LANG=en_US.UTF-8"

# Get prerequisites
pacman --noconfirm -Sy wget git
git config --global url."https://".insteadOf "git://"

# Install arkOS package repo details
wget -O /tmp/arkos-keyring.pkg.tar.xz https://nyus.mirror.arkos.io/x86_64/arkos/arkos-keyring-20150321-1-any.pkg.tar.xz
wget -O /tmp/arkos-mirrorlist.pkg.tar.xz https://nyus.mirror.arkos.io/x86_64/arkos/arkos-mirrorlist-20150413-1-any.pkg.tar.xz
pacman --noconfirm -U /tmp/arkos-keyring.pkg.tar.xz
pacman --noconfirm -U /tmp/arkos-mirrorlist.pkg.tar.xz
curl "https://www.archlinux.org/mirrorlist/?country=CA&protocol=http&ip_version=4" 2>/dev/null > /etc/pacman.d/mirrorlist && sed -i 's/\#Server/Server/g' /etc/pacman.d/mirrorlist

# Update the system
pacman --noconfirm -Syu

# Install system dependencies
pacman --noconfirm --needed -Sy pkg-config binutils gcc iptables python python2 python-pip python2-pip

# Install arkOS packages
pacman --noconfirm -S arkos-configs arkos-core arkos-kraken arkos-genesis

pacman --noconfirm -Scc
