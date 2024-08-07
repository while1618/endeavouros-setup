<h1 align="center">Hyprland on EndeavourOS</h1>

<p align="center">
  <a href="https://github.com/hyprwm/Hyprland" target="_blank"><img alt="Hyprland" src="https://img.shields.io/badge/hyprland-F8BBD0?style=for-the-badge"></a>
  <a href="https://github.com/Alexays/Waybar" target="_blank"><img alt="Waybar" src="https://img.shields.io/badge/waybar-E1C6E7?style=for-the-badge"></a>
  <a href="https://github.com/lbonn/rofi" target="_blank"><img alt="Rofi" src="https://img.shields.io/badge/rofi-FFC09F?style=for-the-badge"></a>
  <a href="https://github.com/ArtsyMacaw/wlogout" target="_blank"><img alt="Wlogout" src="https://img.shields.io/badge/wlogout-FEEF93?style=for-the-badge"></a>
  <a href="https://github.com/hyprwm/hyprlock" target="_blank"><img alt="Hyprlock" src="https://img.shields.io/badge/hyprlock-FCF5C7?style=for-the-badge"></a>
  <a href="https://github.com/hyprwm/hyprpaper" target="_blank"><img alt="Hyprpaper" src="https://img.shields.io/badge/hyprpaper-A0CED9?style=for-the-badge"></a>
  <a href="https://github.com/dunst-project/dunst" target="_blank"><img alt="Dunst" src="https://img.shields.io/badge/dunst-B5EAD7?style=for-the-badge"></a>
  <a href="https://github.com/sddm/sddm" target="_blank"><img alt="SDDM" src="https://img.shields.io/badge/sddm-ADF7B6?style=for-the-badge"></a>
</p>

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

Once the installation is done, login to your system, clone this repository and run `setup.sh`:

``` 
$ git clone https://github.com/while1618/endeavouros-setup.git 
$ cd endeavouros-setup/ 
$ ./setup.sh
```

You'll need to answer some questions about your setup.

Once it's done, reboot and you are good to go.

## Getting Started

When you login for the first time, type `ctrl + super + H` to check all the keybindings, so that you know what you can do. If you want to do any additional customization, I suggest visiting Hyprland [wiki](https://wiki.hyprland.org/), and seek for inspiration on GitHub and Reddit.

## Known Issues

If you are on Nvidia GPU, some electron apps (vscode, discord...) might face some flickering problems, if that's the case, run those apps with `--disable-gpu` flag as suggested in Hyprland [wiki](https://wiki.hyprland.org/Nvidia/#flickering-in-electron--cef-apps). You can add this flag to your `.desktop` files, or run the apps with a flag directly from terminal.

## Credits

The following projects were the main inspirations:
- https://github.com/mylinuxforwork/dotfiles
- https://github.com/JaKooLit/Arch-Hyprland
- https://github.com/adi1090x/rofi
- https://github.com/keyitdev/sddm-astronaut-theme.git
