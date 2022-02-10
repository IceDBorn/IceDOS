#!/bin/bash

username="changethis"

sudo chown "$username:mnt" /mnt/Games --recursive
sudo chown "$username:mnt" /mnt/Storage --recursive
sudo chown "$username:mnt" /mnt/SSDGames --recursive
sudo chown "$username:mnt" /mnt/Windows --recursive
sudo chown "guest:guest" /mnt/guest --recursive
