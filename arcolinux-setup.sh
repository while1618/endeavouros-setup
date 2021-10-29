#!/bin/bash

# Before running check the following link
# https://arcolinux.com/things-to-do-after-arcolinux-installation/

# Things to pick during installation:
# Kernel:
# 	- default
#	- zen
#	- amd/intel ucode(depends on the cpu)
# Drivers:
#	- nvidia proprietary/intel open-source/AMD proprietary or open-source
# Login:
#	- whatever suits you(currently at Sddm)
# Desktop:
#	- whatever suits you(currently at bspwm)
# ArcoLinuxTools:
#	- fun
#	- sddm-themes
#	- steam
#	- utilities
# Communication:
#	- discord
#	- skype
#	- signal
# Development:
# 	- visual-studio-code-bin
# Office:
#	- WPS
#	- okular
# Fonts:
# 	- awesome-terminal-fonts
#	- fira-code
#	- font-awesome
#	- jetbrains-mono
#	- powerlevel10k
#	- ms-fonts
# Multimedia:
#	- obs-studio
#	- vlc
#	- youtube-dl
# Internet:
#	- chromium
#	- firefox
#	- ublock-origin
#	- google-chrome
#	- qbittorrent
#	- dropbox
#	- mailspring
# Theming:
#	- whatever suits you
# Gaming:
#	- meta-steam
#	- lutris
#	- proton-community-updater
#	- steam-buddy
#	- steam-tweaks
# Terminals:
#	- alacritty
#	- oh-my-zsh
#	- powerlevel10k
#	- terminator
# Filemanagers:
#	- dolphin
#	- ranger
# Utilities:
#	- etcher-bin
#	- woeusb
#	- flatpak
#	- snapd
#	- htop
#	- lm_sensors
#	- caffeine
#	- galculator
#	- gufw
#	- stacer
# Applications:
#	- bitwarden
#	- tor-browser
#	- tor
#	- virtualbox for linux kernel
# Partitions:
# 	- swap to file

mirror
update
upall
yay
cleanup
skel
hblock
sudo systemctl enable fstrim.timer
sudo ufw enable
sudo hardcode-fixer
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/100-arcolinux.conf
chsh -s /bin/zsh
reboot
