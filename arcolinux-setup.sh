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

echo "###########################################################################################################################################"
echo "## Before running check the installation script and the following link: https://arcolinux.com/things-to-do-after-arcolinux-installation/ ##"
echo "###########################################################################################################################################"

read -r -p "Have you checked? [Y/n] " check
if [[ "$check" =~ ^([nN][eE][sS]|[nN])$ ]]; then
    echo "######################"
    echo "## Please check it. ##"
    echo "######################"
    exit 1
fi
read -r -p "Are you on tiling window manager? (e.g. bspwm, xmonad...) [y/N]" wm
if [[ "$wm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    read -r -p "On witch? If you have multiple, divide them with 'space'. (e.g. bspwm xmonad): " wms
fi
read -r -p "Are you on NVIDIA gpu? [y/N]" nvidia
read -r -p "Are you on laptop? [y/N]" laptop
echo "Your interfaces: "
ip -o link show | awk -F': ' '{print $2}' | paste -sd ' '
read -r -p "Enter interface name: " interface
read -r -p "Enter your name for git: " git_name
read -r -p "Enter your email for git: " git_email

echo "####################################"
echo "## Load custom arcolinux scripts. ##"
echo "####################################"
[ -d ~/.config ] || mkdir ~/.config && cp -rf /etc/skel/* ~

echo "#####################"
echo "## Update mirrors. ##"
echo "#####################"
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist

echo "####################"
echo "## Update system. ##"
echo "####################"
sudo pacman -Syyu
paru -Syu --noconfirm
yay -Su --noconfirm

echo "#######################"
echo "## Enable utilities. ##"
echo "#######################"
hblock
sudo systemctl enable fstrim.timer
sudo ufw enable
sudo hardcode-fixer
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/100-arcolinux.conf

echo "##################################"
echo "## Change default shell to zsh. ##"
echo "##################################"
chsh -s $(which zsh)

echo "########################"
echo "## zsh customization. ##"
echo "########################"
sudo git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/oh-my-zsh/plugins/zsh-autosuggestions
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/share/oh-my-zsh/themes/powerlevel10k

echo "###########################"
echo "## Install file manager. ##"
echo "###########################"
sudo pacman -Sy nnn

echo "#################"
echo "## git config. ##"
echo "#################"
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"

echo "#########################################################"
echo "## Install mysql - current password for root is empty. ##"
echo "#########################################################"
sudo pacman -Sy mariadb
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

echo "#########################"
echo "## Install postgresql. ##"
echo "#########################"
sudo pacman -Sy postgresql
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo psql -U postgres -c "ALTER USER postgres PASSWORD 'root';"

echo "####################"
echo "## Install redis. ##"
echo "####################"
sudo pacman -Sy redis
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
sudo pacman -Sy docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

echo "#################################################"
echo "## Install java, maven and google-java-format. ##"
echo "#################################################"
sudo pacman -Sy jre-openjdk
sudo pacman -Sy jdk-openjdk
sudo pacman -Sy jre11-openjdk
sudo pacman -Sy jdk11-openjdk
sudo pacman -Sy maven
yay google-java-format

echo "###########################"
echo "## Install node via nvm. ##"
echo "###########################"
yay nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts
npm install -g @angular/cli nx

echo "##################"
echo "## Install pip. ##"
echo "##################"
sudo pacman -Sy python-pip

echo "######################"
echo "## Install postman. ##"
echo "######################"
yay postman-bin

echo "#######################"
echo "## Install intellij. ##"
echo "#######################"
yay intellij-idea-ultimate-edition

echo "######################"
echo "## Install pycharm. ##"
echo "######################"
yay pycharm-professional

if [[ "$wm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "###########################################################################################"
    echo "## Fix for not starting java based apps in tiling window manager (e.g. bspwm, xmonad...) ##"
    echo "###########################################################################################"
    echo "export _JAVA_AWT_WM_NONREPARENTING=1" | sudo tee -a /etc/profile
fi

if [[ "$nvidia" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "########################"
    echo "## NVIDIA GPU config. ##"
    echo "########################"
    sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
    yay gwe
fi

echo "############################################"
echo "## RGB config. -> (r: 200, g: 140: b:255) ##"
echo "############################################"
yay openrgb

echo "#########################################"
echo "## Increase the size of the swap file. ##"
echo "#########################################"
sudo swapoff -a
# set swap file to 8gb
sudo dd if=/dev/zero of=/swapfile bs=1G count=8
sudo mkswap /swapfile
sudo swapon /swapfile

echo "########################"
echo "## Generate ssh keys. ##"
echo "########################"
ssh-keygen

echo "########################################"
echo "## Add themes, fonts and backgrounds. ##"
echo "########################################"
mkdir ~/.themes
mkdir ~/.icons
# gtk
tar xf .themes/Qogir-dark.tar.xz -C ~/.themes/
# icons
tar xf .icons/papirus-icon-theme-20211101.tar.gz -C ~/.icons/
# cursor
tar xf .icons/volantes_light_cursors.tar.gz -C ~/.icons/
# apply themes and icons
cp -rf .gtkrc-2.0.mine ~/
cp -rf .config/gtk-3.0/settings.ini ~/.config/gtk-3.0/
# fonts
cp -rf .fonts/ ~/
# backgrounds
cp -rf .backgrounds ~/

echo "#######################"
echo "## Add config files. ##"
echo "#######################"
cp -rf .bashrc ~/
cp -rf .zshrc ~/
cp -rf .p10k.zsh ~/
cp -rf .config/alacritty/alacritty.yml ~/.config/alacritty/

echo "########################"
echo "## bspwm config files. ##"
echo "########################"
if [[ $wms == *"bspwm"* ]]; then
    cp -rf .config/bspwm/autostart.sh ~/.config/bspwm/
    cp -rf .config/bspwm/bspwmrc ~/.config/bspwm/
    cp -rf .config/bspwm/sxhkd/sxhkdrc ~/.config/bspwm/sxhkd/
    rm -rf ~/.config/rofi/*
    cp -rf .config/rofi/* ~/.config/rofi/
    rm -rf ~/.config/polybar/*
    cp -rf .config/polybar/* ~/.config/polybar/
    chmod +x ~/.config/polybar/*
    if [[ "$laptop" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sed -i "135s/.*/modules-right = cpu memory network updates pulseaudio battery date settings poweroff arrow/" ~/.config/polybar/config.ini
    fi
    sed -i "213s/.*/interface = $interface/" ~/.config/polybar/modules.ini
fi

echo "#####################"
echo "## System cleanup. ##"
echo "#####################"
sudo pacman -Rns $(pacman -Qtdq)
paru -Sc --noconfirm
yay -Sc --noconfirm

echo "#########################################################"
echo "## Done! You should change the default apps if needed. ##"
echo "#########################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
