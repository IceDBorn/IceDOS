#!/bin/bash

# Variables
username=$(whoami)

# Make child scripts executable
sudo chmod +x apps/install.sh apps/uninstall.sh zsh/zsh-plugins.sh  single-gpu-passthrough/single-gpu-passthrough.sh

# Install needed applications
if ! command -v git &> /dev/null
then
    echo "Git is not installed"
    echo "Installing..."
    sudo pacman -S git
else
  echo "Git is installed"
  echo "Skipping..."
fi

if ! command -v subl &> /dev/null
then
    echo "Sublime Text is not installed"
    echo "Installing..."
    yay -S sublime-text-4
else
  echo "Sublime Text is installed"
  echo "Skipping..."
fi

# Default applications uninstaller
while true
do
	read -r -p "Do you want to uninstall default applications? [y/n] " input

 	case $input in [yY][eE][sS]|[yY])
		while true
		do
			read -r -p "Do you want to edit the default applications uninstall script? [y/n] " input

 			case $input in [yY][eE][sS]|[yY])
				echo Press any button when you have finished editing the applications script...
				subl apps/uninstall.sh
				read -r -n 1 -s
				echo Uninstalling applications...
 				./apps/uninstall.sh
 				break
 				;;
 			[nN][oO]|[nN])
				echo Uninstalling applications...
 				./apps/uninstall.sh
 				break
        		;;
    		*)
 				echo "Invalid input..."
 				;;
 			esac
		done
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Generic applications installer
while true
do
	read -r -p "Do you want to install applications? [y/n] " input
 
 	case $input in [yY][eE][sS]|[yY])
		while true
		do
			read -r -p "Do you want to edit the applications script? [y/n] " input
 
 			case $input in [yY][eE][sS]|[yY])
				echo Press any button when you have finished editing the applications script...
				subl apps/install.sh
				read -r -n 1 -s
				echo Installing applications...
 				./apps/install.sh
 				break
 				;;
 			[nN][oO]|[nN])
				echo Installing applications...
 				./apps/install.sh
 				break
        		;;
    		*)
 				echo "Invalid input..."
 				;;
 			esac
		done
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Startup items
if command -v gwe &> /dev/null
then
    echo "GreenWithEnvy is installed..."
    while true
    do
      read -r -p "Do you want to add GreenWithEnvy to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/GreenWithEnvy.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
fi

if command -v ksuperkey &> /dev/null
then
    echo "ksuperkey is installed..."
    while true
    do
      read -r -p "Do you want to add ksuperkey to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/ksuperkey.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
fi

if command -v discord-canary &> /dev/null
then
    echo "Discord Canary is installed..."
    while true
    do
      read -r -p "Do you want to add Discord Canary to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/Powercord.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
fi

if command -v cadmus &> /dev/null
then
    echo "Cadmus is installed..."
    while true
    do
      read -r -p "Do you want to add Cadmus to startup? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        mv apps/Cadmus.desktop /home/"$username"/.config/autostart/
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
fi

# Zsh installer
if ! command -v zsh &> /dev/null
then
    echo "zsh is not installed"
    while true
    do
      read -r -p "Do you want to install zsh? [y/n] " input

      case $input in [yY][eE][sS]|[yY])

        sudo pacman -S zsh

        while true
        do
          read -r -p "Do you want to install zsh plugins? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            while true
            do
              read -r -p "Do you want to edit the zsh plugins script? [y/n] " input

              case $input in [yY][eE][sS]|[yY])
                echo Press any button when you have finished editing the zsh plugins script...
                read -r -n 1 -s
                subl zsh/zsh-plugins.sh
                echo Installing zsh plugins...
                ./zsh/zsh-plugins.sh
                break
                ;;
              [nN][oO]|[nN])
                echo Installing zsh plugins...
                ./zsh/zsh-plugins.sh
                break
                    ;;
                *)
                echo "Invalid input..."
                ;;
              esac
            done
            echo Do not forget to add installed scripts to the zsh config file
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Make zsh the default shell for root? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            sudo chsh -s /bin/zsh root
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Make zsh the default shell for $username? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            sudo chsh -s /bin/zsh "$username"
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Do you want to install provided zsh's theme? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            mv zsh/promptline.sh ~/.promptline.sh
            echo Do not forget to add "'source ~/.promptline.sh'" and "'unsetopt PROMPT_SP'" into the zsh config file!
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        while true
        do
          read -r -p "Do you want to edit zsh's config? [y/n] " input

          case $input in [yY][eE][sS]|[yY])

            while true
            do
              read -r -p "Do you want to edit view recommended additions to the zsh config? [y/n] " input

              case $input in [yY][eE][sS]|[yY])
                subl zsh/zsh-config-additions.txt
                break
                ;;
              [nN][oO]|[nN])
                break
                    ;;
                *)
                echo "Invalid input..."
                ;;
              esac
            done

            echo Press any button when you have finished editing the zsh config...
            subl /home/"$username"/.zshrc
            read -r -n 1 -s
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done

        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
else
  echo "Zsh is installed"
  echo "Skipping..."
fi

# Kitty config installer
if ! command -v kitty &> /dev/null
then
    while true
    do
      read -r -p "Do you want to install kitty? [y/n] " input

      case $input in [yY][eE][sS]|[yY])
        sudo pacman -S kitty

        while true
        do
          read -r -p "Do you want to install kitty's provided config? [y/n] " input

          case $input in [yY][eE][sS]|[yY])
            mv apps/kitty.conf ~/.config/kitty.conf
            break
            ;;
          [nN][oO]|[nN])
            break
                ;;
            *)
            echo "Invalid input..."
            ;;
          esac
        done
        break
        ;;
      [nN][oO]|[nN])
        break
            ;;
        *)
        echo "Invalid input..."
        ;;
      esac
    done
else
  echo "Kitty is installed"
  echo "Skipping..."
fi

# Powercord installer
if command -v discord-canary &> /dev/null
then
  echo "Discord Canary is installed..."
  while true
  do
    read -r -p "Do you want to install powercord? [y/n] " input

    case $input in [yY][eE][sS]|[yY])
      mkdir ~/Projects
      git clone https://github.com/powercord-org/powercord ~/Projects
      (cd ~/Projects/powercord && npm i && npm run plug)
      break
      ;;
    [nN][oO]|[nN])
      break
          ;;
      *)
      echo "Invalid input..."
      ;;
    esac
  done
fi

# Pictures mover
while true
do
	read -r -p "Do you want to move provided pictures to the pictures folder? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
 		mv pictures/arcolinux-hello.png ~/Pictures/.arcolinux-hello.png
 		mv pictures/panel.png ~/Pictures/.panel.png
 		mv pictures/wallpaper.png ~/Pictures/.wallpaper.png
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Enable ssh
while true
do
	read -r -p "Do you want to enable ssh? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
 		sudo systemctl enable sshd
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

# Single gpu passthrough setup
while true
do
	read -r -p "Do you want to setup single gpu passthrough? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
 		./single-gpu-passthrough/single-gpu-passthrough.sh
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done

while true
do
	read -r -p "Do you want to reboot? [y/n] " input

	case $input in [yY][eE][sS]|[yY])
		reboot
 		break
 		;;
 	[nN][oO]|[nN])
 		break
        ;;
    *)
 		echo "Invalid input..."
 		;;
 	esac
done