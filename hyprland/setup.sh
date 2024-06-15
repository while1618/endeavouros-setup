#!/bin/bash

if [ "$(id -u)" = 0 ]; then
    echo "##################################################################"
    echo "This script MUST NOT be run as root user since it makes changes"
    echo "to the \$HOME directory of the \$USER executing this script."
    echo "The \$HOME directory of the root user is, of course, '/root'."
    echo "We don't want to mess around in there. So run this script as a"
    echo "normal user. You will be asked for a sudo password when necessary."
    echo "##################################################################"
    exit 1
fi

clear
GREEN='\033[0;32m'
RED="\e[31m"
NONE='\033[0m'

# ----------------------------------------------------- 
# functions
# ----------------------------------------------------- 

# check if package is installed
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# install required packages
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

# required packages for the installer
installer_packages=(
    "wget"
    "unzip"
    "gum"
    "figlet"
)

echo -e "${GREEN}"
cat <<"EOF"
 _   _                  _                 _ 
| | | |_   _ _ __  _ __| | __ _ _ __   __| |
| |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
|  _  | |_| | |_) | |  | | (_| | | | | (_| |
|_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
       |___/|_|                             

EOF
echo -e "${NONE}"

# ----------------------------------------------------- 
# synchronizing package databases
# ----------------------------------------------------- 
sudo pacman -Sy
echo

# ----------------------------------------------------- 
# install required packages
# ----------------------------------------------------- 
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${installer_packages[@]}";
echo


# ----------------------------------------------------- 
# core packages
# ----------------------------------------------------- 

echo -e "${GREEN}"
figlet "CorePackages"
echo -e "${NONE}"

# packages
sudo pacman -Sy hyprland waybar rofi-wayland dunst hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland sddm \
                alacritty vim zsh picom qt5-wayland qt6-wayland cliphist thunar \
                network-manager-applet blueman brightnessctl \
                ttf-font-awesome otf-font-awesome ttf-fira-sans ttf-fira-code   \
                ttf-firacode-nerd papirus-icon-theme breeze-icons nwg-look \
                --noconfirm
yay -S wlogout waypaper bibata-cursor-theme

# hyprland config app
bash <(curl -s "https://gitlab.com/stephan-raabe/ml4w-hyprland-settings/-/raw/main/setup.sh")

# zsh config
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# starship
curl -sS https://starship.rs/install.sh | sh


# -----------------------------------------------------
# development   
# ----------------------------------------------------- 

# git
echo -e "${GREEN}"
figlet "Git"
echo -e "${NONE}"git_name=$(gum input --placeholder "Enter git name")
git_email=$(gum input --placeholder "Enter git email")
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"
git config --global pull.ff only
ssh-keygen

# java
echo -e "${GREEN}"
figlet "Java"
echo -e "${NONE}"
sudo pacman -Sy jre21-openjdk jdk21-openjdk maven --noconfirm
yay -S google-java-format intellij-idea-ultimate-edition

# python
echo -e "${GREEN}"
figlet "Python"
echo -e "${NONE}"
sudo pacman -Sy python-pip --noconfirm
yay -S pycharm-professional

# haskell
# echo -e "${GREEN}"
# figlet "Haskell"
# echo -e "${NONE}"
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# yay -S hlint-bin

# mysql
echo -e "${GREEN}"
figlet "Mysql"
echo -e "${NONE}"
sudo pacman -Sy mariadb --noconfirm
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

# postgres
echo -e "${GREEN}"
figlet "Postgres"
echo -e "${NONE}"
sudo pacman -Sy postgresql --noconfirm
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable --now postgresql
sudo psql -U postgres -c "ALTER USER postgres PASSWORD 'root';"

# redis
echo -e "${GREEN}"
figlet "Redis"
echo -e "${NONE}"
sudo pacman -Sy redis --noconfirm
sudo systemctl enable --now redis
redis-cli config set requirepass root

# node
echo -e "${GREEN}"
figlet "Node"
echo -e "${NONE}"
yay -S nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts

# docker
echo -e "${GREEN}"
figlet "Docker"
echo -e "${NONE}"
sudo pacman -Sy docker --noconfirm
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
sudo pacman -Sy docker-compose --noconfirm

# vscode
echo -e "${GREEN}"
figlet "VSCode"
echo -e "${NONE}"
sudo pacman -Sy gnome-keyring --noconfirm
yay -S vscode insomnia-bin

# neovim
echo -e "${GREEN}"
figlet "Neovim"
echo -e "${NONE}"
sudo pacman -Sy neovim fzf ripgrep fd --noconfirm
yay -S vim-plug
git clone https://github.com/NvChad/NvChad ~/.config/nvchad --depth
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/astrovim
git clone https://github.com/LazyVim/starter ~/.config/lazyvim


# -----------------------------------------------------
# apps
# ----------------------------------------------------- 

# gui
echo -e "${GREEN}"
figlet "GUI"
echo -e "${NONE}"
sudo pacman -Sy discord okular feh gwenview vlc qbittorrent bitwarden qalculate-gtk gparted veracrypt --noconfirm
yay -S onlyoffice brave-bin ventoy-bin unified-remote-server

# terminal utils
echo -e "${GREEN}"
figlet "TerminalUtils"
echo -e "${NONE}"
sudo pacman -Sy tmux nnn fastfetch --noconfirm


# -----------------------------------------------------
# configs and themes
# ----------------------------------------------------- 

# dotfiles
echo -e "${GREEN}"
figlet "Dotfiles"
echo -e "${NONE}"
cp -rf ./config/.gtkrc-2.0 ./config/.Xresources ./config/.bashrc ./config/.zshrc ~/
mkdir -p ~/.config/qBittorrent && cp -rf ./config/qbittorrent/qbittorrent.qbtheme ~/.config/qBittorrent
rm -rf ~/.mozilla/firefox/*.default-release/** && cp ./config/firefox/prefs.js ~/.mozilla/firefox/*.default-release/
cp -rf ./config/alacritty ./config/dunst ./config/gtk-3.0 ./config/gtk-4.0 ./config/hypr ./config/picom ./config/scripts ./config/wal ./config/waybar ./config/wlogout ~/.config

# rofi
echo -e "${GREEN}"
figlet "Rofi"
echo -e "${NONE}"
git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi
cd ~/rofi
chmod +x setup.sh
sh setup.sh
cd -

# sddm
echo -e "${GREEN}"
figlet "SDDM"
echo -e "${NONE}"
sudo systemctl enable sddm
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

# wallpapers
echo -e "${GREEN}"
figlet "Wallpapers"
echo -e "${NONE}"
cp -r wallpapers/** ~/Pictures

# system configs
echo -e "${GREEN}"
figlet "SystemConfigs"
echo -e "${NONE}"
sudo systemctl enable bluetooth
sudo systemctl enable fstrim.timer

# swapfile
echo -e "${GREEN}"
figlet "Swapfile"
echo -e "${NONE}"
sudo mkswap -U clear --size 8G --file /swapfile
sudo swapon /swapfile
echo -e "${RED}"
figlet "Required!"
echo -e "${NONE}"
echo "Add the following line to the '/etc/fstab':"
echo "/swapfile swap swap defaults 0 0"


# -----------------------------------------------------
# kernel
# -----------------------------------------------------

# zen kernel
echo -e "${GREEN}"
figlet "ZenKernel"
echo -e "${NONE}"
sudo pacman -Sy linux-zen linux-zen-headers --noconfirm
sudo grub-mkconfig -o /boot/grub/grub.cfg

# cleanup
echo -e "${GREEN}"
figlet "Cleanup"
echo -e "${NONE}"
sudo pacman -Rns $(pacman -Qtdq) --noconfirm
yay -Sc --noconfirm

echo -e "${GREEN}"
figlet "Done"
echo -e "${NONE}"

echo
echo "DONE! Please reboot your system!"
