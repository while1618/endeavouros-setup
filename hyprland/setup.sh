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
NONE='\033[0m'

# ----------------------------------------------------- 
# Functions
# ----------------------------------------------------- 

# Check if package is installed
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

# Install required packages
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

# Required packages for the installer
installer_packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
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
# Synchronizing package databases
# ----------------------------------------------------- 
sudo pacman -Sy
echo

# ----------------------------------------------------- 
# Install required packages
# ----------------------------------------------------- 
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${installer_packages[@]}";
echo

# ----------------------------------------------------- 
# Double check rsync
# ----------------------------------------------------- 
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo

# ----------------------------------------------------- 
# Confirm Start
# ----------------------------------------------------- 
echo -e "${GREEN}"
figlet "Installation"
echo -e "${NONE}"
echo "This script will install the following packages:"
echo "hyprland waybar rofi-wayland alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper hyprlock "
echo "ttf-font-awesome vim nwg-look brightnessctl cliphist thunar hypridle wlogout otf-font-awesome ttf-fira-sans ttf-fira-code waypaper "
echo "ttf-firacode-nerd papirus-icon-theme breeze-icons bibata-cursor-theme sddm network-manager-applet blueman fastfetch ufw mariadb "
echo "postgresql redis docker jre11-openjdk jdk11-openjdk jre21-openjdk jdk21-openjdk maven google-java-format nvm python-pip zsh tmux "
echo "discord onlyoffice okular feh gwenview vlc brave-bin qbittorrent bitwarden vscode gnome-keyring insomnia-bin intellij-idea-ultimate-edition "
echo "pycharm-professional neovim vim-plug fzf ripgrep fd nnn qalculate-gtk gparted veracrypt ventoy-bin unified-remote-server picom"
echo
if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
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

# ----------------------------------------------------- 
# Install packages 
# ----------------------------------------------------- 

# Install pacman packages
sudo pacman -Sy hyprland waybar rofi-wayland alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper \
                hyprlock ttf-font-awesome vim cliphist thunar hypridle otf-font-awesome ttf-fira-sans ttf-fira-code nwg-look fastfetch \
                ttf-firacode-nerd papirus-icon-theme breeze-icons sddm network-manager-applet blueman brightnessctl ufw mariadb postgresql \
                redis docker jre11-openjdk jdk11-openjdk jre21-openjdk jdk21-openjdk maven python-pip zsh discord okular feh tmux \
                gwenview vlc qbittorrent bitwarden gnome-keyring neovim fzf ripgrep fd nnn qalculate-gtk gparted veracrypt picom --noconfirm

# Install yay packages
yay -S wlogout waypaper bibata-cursor-theme google-java-format nvm onlyoffice brave-bin vscode insomnia-bin vim-plug \
        intellij-idea-ultimate-edition pycharm-professional ventoy-bin unified-remote-server

# Install haskell
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# yay -S hlint-bin

# Configure mysql
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

# Configure postgres
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable --now postgresql
sudo psql -U postgres -c "ALTER USER postgres PASSWORD 'root';"

# Configure redis
sudo systemctl enable --now redis
redis-cli config set requirepass root

# Configure docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
sudo pacman -Sy docker-compose --noconfirm

# Configure node
source /usr/share/nvm/init-nvm.sh
nvm install --lts

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Configure zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Configure git
git_name=$(gum input --placeholder "Enter git name")
git_email=$(gum input --placeholder "Enter git email")
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"
git config --global pull.ff only

# Generate ssh keys
ssh-keygen

# Enable bluetooth
sudo systemctl enable --now bluetooth

# Enable ssd trim
sudo systemctl enable --now fstrim.timer

# Copy configs
cp -rf ./config/.gtkrc-2.0 ./config/.Xresources ./config/.bashrc ./config/.zshrc ~/
mkdir -p ~/.config/qBittorrent && cp -rf ./config/qbittorrent/qbittorrent.qbtheme ~/.config/qBittorrent
rm -rf ~/.mozilla/firefox/*.default-release/** && cp ./config/firefox/prefs.js ~/.mozilla/firefox/*.default-release/
cp -rf alacritty dunst gtk-3.0 gtk-4.0 hypr picom scripts wal waybar wlogout ~/.config

# nvim configs
git clone https://github.com/NvChad/NvChad ~/.config/nvchad --depth
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/astrovim
git clone https://github.com/LazyVim/starter ~/.config/lazyvim

# SDDM config
sudo systemctl enable --now sddm
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

# Rofi theme
git clone --depth=1 https://github.com/adi1090x/rofi.git
chmod +x rofi/setup.sh
sh rofi/setup.sh

# Copy wallpapers
cp -r wallpapers/** ~/Pictures

# Install ML4W Hyprland Settings App
bash <(curl -s "https://gitlab.com/stephan-raabe/ml4w-hyprland-settings/-/raw/main/setup.sh")

# Default shell zsh
chsh -s $(which zsh)

# Install zen kernel
sudo pacman -Sy linux-zen linux-zen-headers --noconfirm
sudo grub-mkconfig -o /boot/grub/grub.cfg

# system cleanup
sudo pacman -Rns $(pacman -Qtdq) --noconfirm
yay -Sc --noconfirm

# Swapfile
echo -e "${GREEN}"
figlet "Swapfile"
echo -e "${NONE}"
sudo mkswap -U clear --size 8G --file /swapfile
sudo swapon /swapfile
echo "Required!"
echo "edit `/etc/fstab` and add the following line:"
echo "/swapfile swap swap defaults 0 0"

echo -e "${GREEN}"
figlet "Done"
echo -e "${NONE}"

echo
echo "DONE! Please reboot your system!"
