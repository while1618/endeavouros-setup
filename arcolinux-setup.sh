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
#	- fun
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

echo "Before running check the following link"
echo "https://arcolinux.com/things-to-do-after-arcolinux-installation/"
echo "While the script is running, you should customize your theme and change default apps if needed."

read -r -p "Have you checked the installation script before running? [Y/n] " check
if [[ "$check" =~ ^([nN][eE][sS]|[nN])$ ]]
then
    echo "Please check it."
    exit
fi

read -r -p "Are you on NVIDIA gpu? [y/N]" nvidia

# load custom arcolinux scripts
skel

# update system
mirror
update
upall
yay
cleanup

# enable utilities
hblock
sudo systemctl enable fstrim.timer
sudo ufw enable
sudo hardcode-fixer
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/100-arcolinux.conf

# change default shell
chsh -s /bin/zsh

# git
git config --global user.name "Dejan Zdravkovic"
git config --global user.email "bagzi1996@gmail.com"

# mysql (current password for root is empty)
sudo pacman -S mariadb
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

# postgres
sudo pacman -S postgresql
sudo su - postgres -c "initdb -D '/var/lib/postgres/data'"
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo psql -U postgres -c "ALTER USER postgres PASSWORD 'root';"

# redis
sudo pacman -S redis
sudo systemctl enable redis
sudo systemctl start redis
redis-cli config set requirepass root

# mongo
yay mongodb-bin
sudo systemctl enable --now mongodb

# java
sudo pacman -S jre-openjdk
sudo pacman -S jdk-openjdk
sudo pacman -S maven

# node
yay nvm
source /usr/share/nvm/init-nvm.sh
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
nvm install --lts
npm install -g @angular/cli nx

# pip
sudo pacman -S python-pip

# apps
yay postman-bin
yay intellij-idea-ultimate-edition
yay pycharm-professional

if [[ "$nvidia" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # hardware
    # gpu config
    sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
    yay gwe
    # rgb config (r: 200, g: 140: b:255)
    yay openrgb
fi

echo "Done!"

# reboot if needed
read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    reboot
fi
