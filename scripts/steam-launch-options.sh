#!/bin/bash

# Run this in ~/.local/share/Steam/userdata/[UserNumber]/config/
# to add these launch options to every game you've played at least once with this account number
sed -i '/\"Playtime\"/a "LaunchOptions" "mangohud gamemoderun %command%"' localconfig.vdf
