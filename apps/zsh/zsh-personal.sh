# Enable provided zsh script
source ~/.config/zsh/zsh-theme.sh
unsetopt PROMPT_SP

alias aria2c="aria2c -j 16 -s 16"
alias chmod="sudo chmod"
alias clear-keys="sudo rm -rf ~/ local/share/keyrings/* ~/ local/share/kwalletd/*"
alias clear-proton-ge="bash ~/.config/zsh/scripts/.protondown.sh 100"
alias nvidia-max-fan-speed="sudo bash ~/.config/zsh/scripts/.nvidia-fan-control-wayland.sh 100"
alias pacman="sudo pacman"
alias reboot-windows="(sudo grub-set-default 0) && (sudo grub-reboot 2) && (sudo reboot)"
alias restart-pipewire="systemctl --user restart pipewire"
alias ssh="TERM=xterm-256color ssh"
alias sunshine="(export DISPLAY=:0) && (sunshine ~/.config/sunshine/sunshine.conf)"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias update-mirrors="(sudo reflector --latest 200 --sort rate --save /etc/pacman.d/mirrorlist) ; (paru -Syy)"
alias update="(paru -Syu --noconfirm --skipreview) ; (yes | protonup) ; (yes | path-to-mozilla-updater/updater.sh)"
alias vpn-off="mullvad disconnect"
alias vpn-on="mullvad connect"
alias vpn="mullvad status"
