#!/bin/bash

username="changethis"

sudo chown "$username":"$username" /home/"$username"/Games --recursive
sudo chown "$username":"$username" /home/"$username"/Storage --recursive
sudo chown "$username":"$username" /home/"$username"/SSDGames --recursive