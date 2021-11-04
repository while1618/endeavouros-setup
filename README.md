# Arcolinux Setup

## About
This is a script to automatically setup my environment in Arcolinux.
Script will work with any desktop environment but currently have additional configs only for bspwm.

__Run it with care, I'm not responsible for any damage you deal with it.__

## Installation
[Download](https://www.arcolinux.info/downloads/) arcolinux from official site and pick arcolinuxB iso.

Choose "Advance installation" when asked.

### What to pick during the installation:

| Area           | Choose                                                         |
| -------------- | -------------------------------------------------------------- |
| Kernel         | default, zen, amd or intel ucode (depends on the CPU)          |
| Drivers        | depends on the GPU                                             |
| Login Manager  | whatever suits you (currently at Sddm)                         |
| Desktop        | whatever suits you (currently at bspwm)                        |
| ArcoLinuxTools | fun, sddm-themes, steam, utilites                              |
| Communication  | discord, skype, signal                                         |
| Development    | visual-studio-code-bin                                         |
| Office         | WPS, okular                                                    |
| Fonts          | whatever suits you (currently all)                             |
| Multimedia     | obs-studio, vlc, youtube-dl                                    |
| Internet       | firefox, ublock-origin, google-chrome, qbittorrent, mailspring |
| Theming        | whatever suits you (currently all)                             |
| Gaming         | meta-steam, wine, lutris, steam-buddy, steam-tweaks            |
| Terminals      | alacritty, oh-my-zsh, powrlevel10k                             |
| Filemanagers   | dolphin, ranger                                                |
| USB Utilites   | etcher-bin, woeusb                                             |
| Utilities      | flatpak, snapd, htop, lm_sensors, galculator, gufw, stacer     |
| Applications   | bitwarden, tor-browser, tor, virtualbox for linux kernel       |
| Partitions     | swap to file                                                   |

After the installation is done, boot to your system, and run following commands:

``` 
$ git clone https://github.com/while1618/linux-setup-scripts.git 
$ cd linux-setup-scripts 
$ sudo chmod +x arcolinux-setup.sh
$ ./arcolinux-setup.sh
```
