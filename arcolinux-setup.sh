#!/bin/sh

# Things to pick during installation:
# Kernel:
# 	- default
#	- zen
#	- amd/intel ucode(depends on the cpu)
# Drivers:
#	- nvidia proprietary + nvidia-dkms/intel open-source/AMD proprietary or open-source(depends on the gpu)
# Login:
#	- whatever suits you(currently at Sddm)
# Desktop:
#	- whatever suits you(currently at bspwm)
# ArcoLinuxTools:
#	- sddm-themes
#	- steam(if gaming)
#	- utilities
# Communication:
#	- discord
#	- skype
#	- signal
# Development:
# 	- visual-studio-code-bin
# Office:
#	- WPS
#	- okular
# Fonts:
# 	- awesome-terminal-fonts
#	- fira-code
#	- font-awesome
#	- jetbrains-mono
#	- powerlevel10k
#	- ms-fonts
# Multimedia:
#	- obs-studio
#	- vlc
#	- youtube-dl
# Internet:
#	- firefox
#	- ublock-origin
#	- google-chrome
#	- qbittorrent
#	- mailspring
# Theming:
#	- whatever suits you(currently all)
# Gaming:(optional)
#	- meta-steam
#	- wine
#	- lutris
#	- steam-buddy
#	- steam-tweaks
# Terminals:
#	- alacritty
#	- oh-my-zsh
#	- powerlevel10k
# Filemanagers:
#	- dolphin
#	- ranger
# Utilities:
#	- etcher-bin
#	- woeusb
#	- flatpak
#	- snapd
#	- htop
#	- lm_sensors
#	- galculator
#	- gufw
#	- stacer
# Applications:
#	- bitwarden
#	- tor-browser
#	- tor
#	- virtualbox for linux kernel
# Partitions:
# 	- swap to file

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

echo "###############################################################################################################"
echo "## Before running check the following link: https://arcolinux.com/things-to-do-after-arcolinux-installation/ ##"
echo "###############################################################################################################"

read -r -p "Have you checked the installation script before running? [Y/n] " check
if [[ "$check" =~ ^([nN][eE][sS]|[nN])$ ]]
then
    echo "######################"
    echo "## Please check it. ##"
    echo "######################"
    exit 1
fi

read -r -p "Are you on NVIDIA gpu? [y/N]" nvidia
read -r -p "Are you on tiling window manager? (e.g. bspwm, xmonad...) [y/N]" wm
read -r -p "Enter your name for git: " git_name
read -r -p "Enter your email for git: " git_email

echo "####################################"
echo "## Load custom arcolinux scripts. ##"
echo "####################################"
[ -d ~/.config ] || mkdir ~/.config && cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -rf /etc/skel/* ~ # alias -> skel

echo "#####################"
echo "## Update mirrors. ##"
echo "#####################"
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist # alias -> mirror

echo "####################"
echo "## Update system. ##"
echo "####################"
sudo pacman -Syyu # alias -> update
paru -Syu --noconfirm # alias -> upall
yay -Su

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
sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "#################"
echo "## git config. ##"
echo "#################"
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"

echo "#########################################################"
echo "## Install mysql - current password for root is empty. ##"
echo "#########################################################"
sudo pacman -S mariadb
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

echo "#########################"
echo "## Install postgresql. ##"
echo "#########################"
sudo pacman -S postgresql
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo psql -U postgres -c "ALTER USER postgres PASSWORD 'root';"

echo "####################"
echo "## Install redis. ##"
echo "####################"
sudo pacman -S redis
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
sudo pacman -S docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

echo "#############################"
echo "## Install java and maven. ##"
echo "#############################"
sudo pacman -S jre-openjdk
sudo pacman -S jdk-openjdk
sudo pacman -S maven

echo "###################"
echo "## Install node. ##"
echo "###################"
yay nvm
source /usr/share/nvm/init-nvm.sh
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
nvm install --lts
npm install -g @angular/cli nx

echo "##################"
echo "## Install pip. ##"
echo "##################"
sudo pacman -S python-pip

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

if [[ "$wm" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "###########################################################################################"
    echo "## Fix for not starting java based apps in tiling window manager (e.g. bspwm, xmonad...) ##"
    echo "###########################################################################################"
    echo "export _JAVA_AWT_WM_NONREPARENTING=1" | sudo tee -a /etc/profile
fi

if [[ "$nvidia" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "#################"
    echo "## GPU config. ##"
    echo "#################"
    sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
    yay gwe
    echo "############################################"
    echo "## RGB config. -> (r: 200, g: 140: b:255) ##"
    echo "############################################"
    yay openrgb
fi

echo "##################################"
echo "## Remove conky from autostart. ##"
echo "##################################"
rm ~/.config/autostart/am-conky-session.desktop

echo "#####################"
echo "## System cleanup. ##"
echo "#####################"
sudo pacman -Rns $(pacman -Qtdq) # alias -> cleanup
paru -Sc
yay -Sc

echo "##############################################################################"
echo "## Done! You should customize your theme and change default apps if needed. ##"
echo "##############################################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    reboot
fi
