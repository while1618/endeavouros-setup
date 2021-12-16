# EndeavourOS Setup

![Screenshot](/screenshots/screenshot.jpg?raw=true)

## About
The script is used to automatically setup my [EndeavourOS](https://endeavouros.com/) with [bspwm](https://github.com/baskerville/bspwm) tiling window manager and [NordTheme](https://www.nordtheme.com/) favour.

The script will work for the most users, but keep in mind that it has some specific apps and configs only for my needs and hardware. Check the script before running and tweak it to your needs.

__Run it with care, I'm not responsible for any damage you deal with it.__

## Installation
- [Download](https://endeavouros.com/latest-release/) EndeavourOS from official website.
- Make a bootable usb.
- Choose UEFI Default if on amd or intel gpu or UEFI NVIDIA if on nvidia gpu.
- Choose "Install community editions".

### What to pick during the installation:

| Area          | Choose                                   |
| ------------- | ---------------------------------------- |
| Partitions    | swap to file                             |
| Editions      | bspwm                                    |
| Base Packages | Base-devel + Common packages, Zen Kernel |

After the installation is done, boot to your system, and run the following commands:

``` 
$ git clone https://github.com/while1618/endeavouros-setup.git 
$ cd endeavouros-setup/ 
$ chmod +x setup.sh
$ ./setup.sh
```
