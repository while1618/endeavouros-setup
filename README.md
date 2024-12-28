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

This script is used to install [Hyprland](https://hyprland.org/) on [EndeavourOS](https://endeavouros.com/). It is tested only with EndeavourOS, but it will probably work on other Arch base distros.

The script will install all the core packages that Hyprland requires, copy dotfiles and wallpapers, install additional software that I use, and install GPU drivers if you are using Nvidia GPU. You can change all of this in `install.sh`, but be careful what you are doing there, because it can break things. 

## Installation
- Download [EndeavourOS](https://endeavouros.com/) from the official website and start the installation.
- I recommend that you pick `Online` installation and go with `No Desktop`.

Once the installation is done, login to your system, clone this repository and run `install.sh`:

``` 
$ git clone https://github.com/while1618/hyprland-install-script.git 
$ cd hyprland-install-script/ 
$ ./install.sh
```

You'll need to answer some questions about your system.

Once it's done, reboot and you are good to go.

## First Login

- On login screen (sddm) change `session` from `hyprland systemd` to `hyprland`.
- When you login, type `ctrl + super + H` to check all the keybindings, so that you know what you can do.
- If you want to do any additional customization, I suggest visiting Hyprland [wiki](https://wiki.hyprland.org/), and seek for inspiration on GitHub and Reddit.

## Known Issues

- Flickering in electron apps (vscode, discord...) on Nvidia GPUs should be resolved with adding [this config](https://github.com/hyprwm/Hyprland/issues/7252#issuecomment-2345792172) to `hyprland.conf`. The script will do that for you if you are on Nvidia GPU, and everything should work fine, but if you still face some flickering problems, run electron apps with `--disable-gpu-compositing` flag. You can add this flag to your `.desktop` files, or run the apps with a flag directly from terminal.
- [db.lck is present](https://github.com/while1618/hyprland-install-script/issues/1)

## Credits

The following projects were the main inspirations:
- https://github.com/mylinuxforwork/dotfiles
- https://github.com/JaKooLit/Arch-Hyprland
- https://github.com/adi1090x/rofi
- https://github.com/keyitdev/sddm-astronaut-theme.git
