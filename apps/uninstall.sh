# Add your apps uninstall commands into this array
apps=(
"sudo pacman -Rd vim"
"sudo pacman -Rd termite"
)

# Uninstall every app using commands inside of array
for command in "${!apps[@]}"
do
  eval "${apps[command]}"
done
