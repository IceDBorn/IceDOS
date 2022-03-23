#!/bin/bash

username="changethis"

sudo chown "$username:$username" /mnt/Games --recursive
sudo chown "$username:$username" /mnt/Storage --recursive
sudo chown "$username:$username" /mnt/SSDGames --recursive
sudo chown "$username:$username" /mnt/Windows --recursive
