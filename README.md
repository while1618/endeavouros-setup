# EndeavourOS on Hyprland 

![Screenshot](/screenshots/screenshot_1.png?raw=true)

![Screenshot](/screenshots/screenshot_2.png?raw=true)

![Screenshot](/screenshots/screenshot_3.png?raw=true)

![Screenshot](/screenshots/screenshot_4.png?raw=true)

![Screenshot](/screenshots/screenshot_5.png?raw=true)

## About

This script is used to setup [Hyprland](https://hyprland.org/) on freshly installed [EndeavourOS](https://endeavouros.com/). It is tested only on EndeavourOS, but it will probably work on other Arch base distros.

The script will install all the core packages that Hyprland requires, copy dotfiles and wallpapers, install additional software that I use, and setup drivers if you are on Nvidia. You can change all of this in `setup.sh`, but be careful what you are doing there, because it can break things. 

## Installation
- Download [EndeavourOS](https://endeavouros.com/) from the official website and start the installation.
- I recommend that you pick `Online` installation and go with `No Desktop`.

Once the installation is done, login to your system, clone this repository and start the setup script

``` 
$ git clone https://github.com/while1618/endeavouros-setup.git 
$ cd endeavouros-setup/ 
$ ./setup.sh
```

You'll need to answer some basic questions for your setup.

Once it's done, reboot and you are good to go.

## Get Started

When you login to your system, type `ctrl + super + H` to check all the keybindings, so that you know what you can do. If you want to do any additional customization, I suggest visiting Hyprland [wiki](https://wiki.hyprland.org/), and seek for inspiration on GitHub and Reddit.

## Known Issues

If you are on Nvidia GPU, some electron apps (vscode, discord...) might face some flickering problems, if that's the case, run those apps with `--disable-gpu` flag as suggested in Hyprland [wiki](https://wiki.hyprland.org/Nvidia/). You can add this flag to your `.desktop` files, or run the apps with a flag directly from terminal.

## Credits

Core projects used:
- https://github.com/hyprwm/Hyprland
- https://github.com/Alexays/Waybar
- https://github.com/lbonn/rofi
- https://github.com/ArtsyMacaw/wlogout
- https://github.com/hyprwm/hyprlock
- https://github.com/dunst-project/dunst
- https://github.com/sddm/sddm

The following projects were the main inspirations for this setup:
- https://github.com/mylinuxforwork/dotfiles
- https://github.com/JaKooLit/Arch-Hyprland
- https://github.com/adi1090x/rofi
- https://github.com/keyitdev/sddm-astronaut-theme.git
