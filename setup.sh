#!/bin/bash

if [ "$(id -u)" = 0 ]; then
    echo ":: This script shouldn't be run as root."
    exit 1
fi

clear
GREEN='\033[0;32m'
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

if gum confirm "You should check the installation script before you continue? Have you?" ;then
    echo
    echo ":: Installing Hyprland and additional packages"
    echo
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Installation canceled."
    exit;
fi

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

echo "What is the resolution and refresh rate of your monitor?"
echo "Answare in the following format eg. 3440x1440@144"
resolution=$(gum input --placeholder "Resolution and refresh rate...")
echo "Resolution and refresh rate: ${resolution}"

if gum confirm "Are you using Nvidia GPU?" ;then
    nvidia=true
    echo
    echo ":: Nvidia GPU is not officially supported by Hyprland. If you face any problems, please check Hyprland Wiki"
    echo ":: https://wiki.hyprland.org/Nvidia/"
    echo
    if gum confirm "Continue?" ;then
        echo
        echo ":: Installing Nvidia GPU Drivers"
        echo
        nvidia-inst
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo
        echo ":: Installation canceled."
        exit;
    fi
fi

# make yay faster - do not use compression
sudo sed -i "s/PKGEXT=.*/PKGEXT='.pkg.tar'/g" /etc/makepkg.conf
sudo sed -i "s/SRCEXT=.*/SRCEXT='.src.tar'/g" /etc/makepkg.conf

# ----------------------------------------------------- 
# core packages
# ----------------------------------------------------- 

echo -e "${GREEN}"
figlet "CorePackages"
echo -e "${NONE}"

# packages
sudo pacman -Sy hyprland waybar rofi-wayland dunst hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland sddm \
                alacritty vim zsh picom qt5-wayland qt6-wayland cliphist thunar gvfs thunar-volman \
                network-manager-applet blueman brightnessctl \
                ttf-font-awesome otf-font-awesome ttf-fira-sans ttf-fira-code   \
                ttf-firacode-nerd papirus-icon-theme gnome-themes-extra gtk-engine-murrine nwg-look \
                --noconfirm
yay -S wlogout waypaper bibata-cursor-theme orchis-theme --noconfirm

# hyprland config app
bash <(curl -s "https://gitlab.com/stephan-raabe/ml4w-hyprland-settings/-/raw/main/setup.sh")

# oh my zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k


# -----------------------------------------------------
# development   
# ----------------------------------------------------- 

# git
echo -e "${GREEN}"
figlet "Git"
echo -e "${NONE}"
git_name=$(gum input --placeholder "Enter git name...")
echo "Name: ${git_name}"
git_email=$(gum input --placeholder "Enter git email...")
echo "Email: ${git_email}"
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"
git config --global pull.ff only
ssh-keygen

# java
echo -e "${GREEN}"
figlet "Java"
echo -e "${NONE}"
sudo pacman -Sy jre21-openjdk jdk21-openjdk maven --noconfirm
yay -S google-java-format intellij-idea-ultimate-edition --noconfirm

# python
echo -e "${GREEN}"
figlet "Python"
echo -e "${NONE}"
sudo pacman -Sy python-pip --noconfirm
yay -S pycharm-professional --noconfirm

# haskell
# echo -e "${GREEN}"
# figlet "Haskell"
# echo -e "${NONE}"
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# yay -S hlint-bin --noconfirm

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
yay -S nvm --noconfirm
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
yay -S vscode --noconfirm

# rest client
yay -S insomnia-bin --noconfirm

# neovim
echo -e "${GREEN}"
figlet "Neovim"
echo -e "${NONE}"
sudo pacman -Sy neovim fzf ripgrep fd --noconfirm
yay -S vim-plug --noconfirm
git clone https://github.com/NvChad/starter ~/.config/nvchad
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/astronvim
git clone https://github.com/LazyVim/starter ~/.config/lazyvim


# -----------------------------------------------------
# apps
# ----------------------------------------------------- 

# gui
echo -e "${GREEN}"
figlet "GUI"
echo -e "${NONE}"
sudo pacman -Sy discord okular feh gwenview vlc qbittorrent bitwarden qalculate-gtk veracrypt --noconfirm
yay -S onlyoffice brave-bin ventoy-bin unified-remote-server --noconfirm

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

if $nvidia ;then
    echo \
"# ----------------------------------------------------- 
# Environment Variables
# ----------------------------------------------------- 

# https://wiki.hyprland.org/Nvidia/
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia" > ./config/hypr/conf/environment.conf
fi

echo \
"# ----------------------------------------------------- 
# Monitor Setup
# ----------------------------------------------------- 

monitor=,${resolution},auto,1" > ./config/hypr/conf/monitor.conf

cp -rf ./config/.gtkrc-2.0 ./config/.Xresources ./config/.bashrc ./config/.zshrc ./config/.p10k.zsh ~/
mkdir -p ~/.config/qBittorrent && cp -rf ./config/qbittorrent/qbittorrent.qbtheme ~/.config/qBittorrent
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
rm -rf ~/rofi

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
echo "/swapfile				  swap		 swap	 defaults   0 0" | sudo tee -a /etc/fstab


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
