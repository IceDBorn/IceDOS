#!/bin/bash

mkdir -p ~/.config/systemd/user/
cp settings/services/"$1".service ~/.config/systemd/user/"$1".service
systemctl --user daemon-reload
systemctl --user start "$1" && systemctl --user enable "$1"
