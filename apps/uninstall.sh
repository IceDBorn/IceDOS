# Add your apps uninstall commands into this array
apps=(
"sudo pacman -Rd mousepad"
"sudo pacman -Rd xfce4-taskmanager"
"sudo pacman -Rd variety"
"sudo pacman -Rd vim"
"sudo pacman -Rd termite"
"sudo pacman -Rd xfce4-terminal"
"sudo pacman -Rd xfce4-dict"
"sudo pacman -Rd xfburn"
"sudo pacman -Rd xfce4-screenshooter"
"sudo pacman -Rd xfce4-notes-plugin"
"sudo pacman -Rd xfce4-sensors-plugin"
)

# Uninstall every app using commands inside of array
for command in "${!apps[@]}"
do
  eval "${apps[command]}"
done
