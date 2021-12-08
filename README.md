# Arcolinux Setup

![Screenshot](/screenshots/screenshot.jpg?raw=true)

## About
This script is used to automatically set my arcolinux env with bspwm as window manager. Keep in mind that the script will work 
for most users, but it has some specific configs only for my setup (e.g. monitor resolution and refresh rate, rgb, gpu).

__Run it with care, I'm not responsible for any damage you deal with it.__

## Installation
[Download](https://www.arcolinux.info/downloads/) arcolinux from official site and pick arcolinuxB-bspwm iso.

Choose "Advance installation" when asked.

### What to pick during the installation:

| Area             | Choose                                                      |
| ---------------- | ----------------------------------------------------------- |
| Kernel           | linux, zen, amd-ucode (pc) or intel-ucode (laptop)          |
| Drivers          | nvidia and nvidia-dkms (pc) or intel (laptop)               |
| Login            | sddm                                                        |
| Desktop          | bspwm                                                       |
| ArcoLinux Tools  | fun, sddm-themes, utilites, steam (pc only), wine (pc only) |
| Communication    | discord, signal, skype (laptop only)                        |
| Development      | visual-studio-code-bin                                      |
| Office           | WPS, okular                                                 |
| Fonts            | all                                                         |
| Multimedia       | obs-studio, vlc, youtube-dl                                 |
| Internet         | firefox, brave, qbittorrent, mailspring                     |
| Theming          | none                                                        |
| Graphics         | none                                                        |
| Gaming (pc only) | lutris, steam-buddy, steam-tweaks                           |
| Terminals        | alacritty                                                   |
| Filemanagers     | nemo, nemo-fileroller                                       |
| Usb Utilites     | etcher-bin                                                  |
| Utilities        | flatpak, snapd, htop, lm_sensors, galculator, gufw          |
| Applications     | bitwarden, tor-browser, tor, virtualbox for linux kernel    |
| Arcolinux Dev    | none                                                        |
| Partitions       | swap to file                                                |

After the installation is done, boot to your system, and run following commands:

``` 
$ skel
$ git clone https://github.com/while1618/arcolinux-setup.git 
$ cd arcolinux-setup/ 
$ chmod +x arcolinux-setup.sh
$ ./arcolinux-setup.sh
```
