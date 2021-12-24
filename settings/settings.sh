#!/bin/bash

username=$(whoami)

# Enable SDDM
echo "Enabling SDDM..."
sudo systemctl enable sddm

# Enable bluetooth audio devices
echo "Enabling headphones support for bluetooth..."
sed -i '/General/a Enable=Source,Sink,Media,Socket' /etc/bluetooth/main.conf

# Add autostart items
echo "Adding autostart items..."
mkdir ~/.config
cp -a settings/autostart ~/.config/

# Auto mount disks on startup
echo "Adding mounts to fstab..."
cat /etc/fstab settings/fstab > ~/.fstab.new
sudo mv /etc/fstab /etc/fstab.old
sudo mv ~/.fstab.new /etc/fstab

# Create folders for HDD mounts and change permissions now and on startup
echo "Creating folders for mounts..."
mkdir ~/Games
mkdir ~/Storage
mkdir ~/SSDGames
sudo chown "$username":"$username" ~/Games --recursive
sudo chown "$username":"$username" ~/Storage --recursive
sudo chown "$username":"$username" ~/SSDGames --recursive
sed -i "s|changethis|$username|" settings/services/chown-disks.sh
bash ./scripts/add-system-service.sh chown-disks

# Enable nvidia overclocking
echo "Enabling nvidia overclocking..."
sudo nvidia-xconfig --cool-bits=31

# Maximize nvidia GPU power limit on startup
echo "Maximizing GPU power limit..."
bash ./scripts/add-system-service.sh nv-power-limit

# Enable wol service
echo "Enabling wake on lan service..."
bash ./scripts/add-system-service.sh wol

# Add noisetorch service
echo "Adding noisetorch service..."
bash ./scripts/add-user-service.sh noisetorch

# Enable Signal's tray icon
echo "Enabling signal's tray icon..."
mkdir -p ~/.local/share/applications
sudo cp settings/autostart/signal-desktop.desktop ~/.local/share/applications/signal-desktop.desktop

# Set hard/soft memlock limits to 2 GBs (required by RPCS3)
echo "Setting hard/soft memlock limits to 2 GBs..."
cat /etc/security/limits.conf settings/limits.txt > /etc/security/limits.conf.new
mv /etc/security/limits.conf /etc/security/limits.conf.old
mv /etc/security/limits.conf.new /etc/security/limits.conf

# Pictures
echo "Adding pictures to the Pictures directory..."
mkdir ~/Pictures
cp settings/pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
cp settings/pictures/wallpaper.png ~/Pictures/.wallpaper.png

# SDDM config
echo "Installing SDDM config..."
sudo mkdir -p /etc/sddm.conf.d/
mkdir -p ~/.config/sddm
cp settings/autologin.conf settings/autologin.conf.old
sed -i "s|changethis|$username|" settings/autologin.conf
cp settings/autologin.conf ~/.config/sddm/
cp settings/passwordlogin.conf ~/.config/sddm/
mv settings/autologin.conf.old settings/autologin.conf

# nvm installer
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Enable ssh
echo "Enabling ssh..."
sudo systemctl enable sshd

# Enable bluetooth
echo "Enabling bluetooth..."
sudo systemctl enable bluetooth

# Default soundux to start to tray
echo "Defaulting soundux to start to tray..."
cp settings/autostart/soundux.desktop ~/.local/share/applications/soundux.desktop

# Custom desktop files
echo "Installing custom desktop files..."
cp -a settings/applications/ ~/.local/share/

# Generate GPG key
echo "Generating GPG key..."
gpg --gen-key

# Add feedback to sudo password
echo "Adding password feedback to sudo..."
echo "Defaults pwfeedback" | sudo tee -a /etc/sudoers

# Set global KDE theme
echo "Setting Materia Dark as global theme..."
lookandfeeltool -a com.github.varlesh.materia-dark

# Update grub
echo "Updating grub..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Add mozilla custom profile
echo "Adding custom mozilla profile..."
randomPath="$HOME/.mozilla/firefox/$RANDOM.privacy"
mkdir -p "$randomPath"
cp settings/user-overrides.js "$randomPath"/user-overrides.js
git clone https://github.com/arkenfox/user.js.git
cp user.js/updater.sh "$randomPath"/updater.sh
cp apps/zsh/zsh-config-append-content.txt apps/zsh/zsh-config-append-content.txt
sed -i "s|path-to-mozilla-updater|$randomPath|" zsh/zsh-custom-config.txt
