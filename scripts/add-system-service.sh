#!/bin/bash

sudo cp settings/services/"$1".sh /usr/local/sbin/"$1".sh
sudo chmod 744 /usr/local/sbin/"$1".sh
sudo mkdir -p /usr/local/etc/systemd
sudo cp settings/services/"$1".service /usr/local/etc/systemd/"$1".service
sudo chmod 644 /usr/local/etc/systemd/"$1".service
sudo ln -s /usr/local/etc/systemd/"$1".service /etc/systemd/system/"$1".service
sudo systemctl start "$1".service
sudo systemctl enable "$1".service
