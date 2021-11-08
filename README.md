# Arcolinux Setup

## About
This is a script to automatically setup my environment in arcolinux.
The script will work with any desktop environment but currently have additional configs only for bspwm.

__Run it with care, I'm not responsible for any damage you deal with it.__

## Installation
[Download](https://www.arcolinux.info/downloads/) arcolinux from official site and pick arcolinuxB-bspwm iso.

Choose "Advance installation" when asked.

### What to pick during the installation:

| Area              | Choose                                                         |
| ----------------- | -------------------------------------------------------------- |
| Kernel            | default, zen, amd or intel ucode (depends on the CPU)          |
| Drivers           | depends on the GPU                                             |
| Login             | whatever suits you (currently at Sddm)                         |
| Desktop           | whatever suits you (currently at bspwm)                        |
| ArcoLinux Tools   | fun, sddm-themes, steam (if gaming), utilites                  |
| Communication     | discord, skype, signal                                         |
| Development       | visual-studio-code-bin                                         |
| Office            | WPS, okular                                                    |
| Fonts             | whatever suits you (currently all)                             |
| Multimedia        | obs-studio, vlc, youtube-dl                                    |
| Internet          | firefox, ublock-origin, chromium, qbittorrent, mailspring      |
| Theming           | whatever suits you (currently none)                            |
| Graphics          | none                                                           |
| Gaming (optional) | meta-steam, wine, lutris, steam-buddy, steam-tweaks            |
| Terminals         | alacritty                                                      |
| Filemanagers      | nemo, nemo-fileroller                                          |
| Usb Utilites      | etcher-bin, woeusb                                             |
| Utilities         | flatpak, snapd, htop, lm_sensors, galculator, gufw, stacer-bin |
| Applications      | bitwarden, tor-browser, tor, virtualbox for linux kernel       |
| Arcolinux Dev     | none                                                           |
| Partitions        | swap to file                                                   |

After the installation is done, boot to your system, and run following commands:

``` 
$ skel
$ git clone https://github.com/while1618/arcolinux-setup.git 
$ cd arcolinux-setup/ 
$ chmod +x arcolinux-setup.sh
$ ./arcolinux-setup.sh
```
