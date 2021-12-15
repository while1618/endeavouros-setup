#!/bin/sh

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

echo "###################################################"
echo "## Before running check the installation script. ##"
echo "###################################################"

read -r -p "Have you checked? [Y/n] " check
if [[ "$check" =~ ^([nN][eE][sS]|[nN])$ ]]; then
    echo "######################"
    echo "## Please check it. ##"
    echo "######################"
    exit 1
fi
read -r -p "On which platform are you runinng? [laptop/pc] " platform
read -r -p "Enter the size of the swap file (e.g. 8 for 8gb): " swap
read -r -p "Enter git name: " git_name
read -r -p "Enter git email: " git_email

echo "####################"
echo "## Update system. ##"
echo "####################"
sudo pacman -Syyu --noconfirm
yay -Su --noconfirm

echo "######################"
echo "## Enable firewall. ##"
echo "######################"
sudo pacman -Sy ufw --noconfirm
sudo ufw enable

echo "###############"
echo "## SSD Trim. ##"
echo "###############"
sudo systemctl enable fstrim.timer

echo "###########"
echo "## Swap. ##"
echo "###########"
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/100-arcolinux.conf
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1G count=$swap
sudo mkswap /swapfile
sudo swapon /swapfile

echo "#################"
echo "## Git config. ##"
echo "#################"
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"
git config --global pull.ff only

echo "########################"
echo "## Generate ssh keys. ##"
echo "########################"
ssh-keygen

echo "#########################################################"
echo "## Install mysql - current password for root is empty. ##"
echo "#########################################################"
sudo pacman -Sy mariadb --noconfirm
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

echo "#########################"
echo "## Install postgresql. ##"
echo "#########################"
sudo pacman -Sy postgresql --noconfirm
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo psql -U postgres -c "ALTER USER postgres PASSWORD 'root';"

echo "####################"
echo "## Install redis. ##"
echo "####################"
sudo pacman -Sy redis --noconfirm
sudo systemctl enable redis
sudo systemctl start redis
redis-cli config set requirepass root

echo "####################"
echo "## Install mongo. ##"
echo "####################"
yay mongodb-bin
sudo systemctl enable --now mongodb

echo "#####################"
echo "## Install docker. ##"
echo "#####################"
sudo pacman -Sy docker --noconfirm
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

echo "#################################################"
echo "## Install java, maven and google-java-format. ##"
echo "#################################################"
sudo pacman -Sy jre11-openjdk --noconfirm
sudo pacman -Sy jdk11-openjdk --noconfirm
sudo pacman -Sy jre-openjdk --noconfirm
sudo pacman -Sy jdk-openjdk --noconfirm
sudo pacman -Sy maven --noconfirm
yay google-java-format

echo "###########################"
echo "## Install node via nvm. ##"
echo "###########################"
yay nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts

echo "##########################################"
echo "## Install angular cli and nx globally. ##"
echo "##########################################"
npm install -g @angular/cli nx

echo "##################"
echo "## Install pip. ##"
echo "##################"
sudo pacman -Sy python-pip --noconfirm

echo "##################"
echo "## Install zsh. ##"
echo "##################"
sudo pacman -Sy zsh --noconfirm
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

echo "###################################################"
echo "## Fix for not starting java based apps in bspwm ##"
echo "###################################################"
echo "export _JAVA_AWT_WM_NONREPARENTING=1" | sudo tee -a /etc/profile

echo "###################"
echo "## Install apps. ##"
echo "###################"
sudo pacman -Sy signal-desktop --noconfirm
sudo pacman -Sy discord --noconfirm
yay onlyoffice
sudo pacman -Sy okular --noconfirm
sudo pacman -Sy mpv --noconfirm
yay brave
sudo pacman -Sy tor --noconfirm
yay tor-browser
sudo pacman -Sy qbittorrent --noconfirm
sudo pacman -Sy bitwarden --noconfirm
sudo pacman -Sy alacritty --noconfirm
yay vscode
yay postman-bin
yay intellij-idea-ultimate-edition
yay pycharm-professional
sudo pacman -Sy vim --noconfirm
sudo pacman -Sy neovim --noconfirm
yay vim-plug
sudo pacman -Sy fzf --noconfirm
sudo pacman -Sy ripgrep --noconfirm
sudo pacman -Sy nnn --noconfirm
sudo pacman -Sy virtualbox --noconfirm
sudo pacman -Sy qalculate-gtk --noconfirm
yay etcher-bin
yay woeusb-gui

echo "########################################"
echo "## Add themes, fonts and backgrounds. ##"
echo "########################################"
mkdir -p ~/.themes && tar xf themes/Nordic-darker-v40.tar.xz -C ~/.themes/
mkdir -p ~/.icons && tar xf icons/papirus-icon-theme-nordic-folders.tar.xz -C ~/.icons/
tar xf icons/volantes_light_cursors.tar.gz -C ~/.icons/
mkdir -p ~/.fonts && cp -rf fonts/** ~/.fonts/
mkdir -p ~/.backgrounds && cp -rf backgrounds/** ~/.backgrounds/

echo "#######################"
echo "## Add config files. ##"
echo "#######################"
mkdir -p ~/.config/alacritty/ && cp -rf config/alacritty/** ~/.config/alacritty/
cp -rf config/bspwm/** ~/.config/bspwm/
cp -rf config/polybar/** ~/.config/polybar/
cp -rf config/rofi/** ~/.config/rofi/
cp -rf config/sxhkd/** ~/.config/sxhkd/
rm -rf ~/.mozilla/firefox/********.default-release/**
cp config/firefox/prefs.js ~/.mozilla/firefox/********.default-release/
cp -rf config/shell/.bashrc ~/
cp -rf config/shell/.zshrc ~/
cp -rf config/shell/.p10k.zsh ~/

if [[ "$platform" == "laptop" ]]; then
    echo "#############"
    echo "## Laptop. ##"
    echo "#############"
    sed -i "62s/.*/modules-right = cpu sps memory sps pulseaudio sps brightness sps battery sps updates sps date/" ~/.config/polybar/config.ini
    sed -i "227s/.*/label-maxlen = 75/" ~/.config/polybar/config.ini
    sed -i "187s/.*/  size: 7.0/" ~/.config/alacritty/alacritty.yml
    echo "xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Natural Scrolling Enabled' 1 &" | tee -a ~/.config/bspwm/bspwmrc
    echo "HandleLidSwitch=ignore" | sudo tee -a /etc/systemd/logind.conf
elif [[ "$platform" == "pc" ]]; then
    echo "#########"
    echo "## PC. ##"
    echo "#########"
    sudo nvidia-installer-dkms
    sudo nvidia-xconfig
    sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
    sudo pacman -Sy psensor --noconfirm
    sudo pacman -Sy piper --noconfirm
    sudo pacman -Sy steam --noconfirm
    sudo pacman -Sy wine --noconfirm
    sudo pacman -Sy lutris --noconfirm
    yay gwe         # gpu fan config -> (50-0, 54-8, 58-18, 60-60, 65-80, 70-100)
    yay openrgb     # rgb config -> (r: 200, g: 140: b:255)
    echo "xrandr --output DP-4 --mode 3440x1440 --rate 144.00 &" | tee -a ~/.config/bspwm/bspwmrc
    echo "run gwe --hide-window &" | tee -a ~/.config/bspwm/bspwmrc
else
    echo "#######################"
    echo "## Unknown platform. ##"
    echo "#######################"
fi

echo "##################################"
echo "## Change default shell to zsh. ##"
echo "##################################"
chsh -s $(which zsh)

echo "#####################"
echo "## System cleanup. ##"
echo "#####################"
sudo pacman -Rns $(pacman -Qtdq) --noconfirm
yay -Sc --noconfirm

echo "###########################################################################"
echo "Done!"
echo "Change the default apps if needed."
echo "Change background."
echo "Apply nordic theme, papirus-dark icons and volantes cursor in lxappearance."
echo "###########################################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
