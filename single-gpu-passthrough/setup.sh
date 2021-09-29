# Variables
username=$(whoami)

# Install necessary applications
echo "Installing necessary applications..."
apps=(
"sudo pacman -S qemu --noconfirm"
"sudo pacman -S libvirt --noconfirm"
"sudo pacman -S edk2-ovmf --noconfirm"
"sudo pacman -S virt-manager --noconfirm"
"sudo pacman -S ebtables --noconfirm"
"sudo pacman -S dnsmasq --noconfirm"
"sudo systemctl enable libvirtd.service"
"sudo systemctl start libvirtd.service"
"sudo systemctl enable virtlogd.socket"
"sudo systemctl start virtlogd.socket"
"sudo virsh net-autostart default"
"sudo virsh net-start default"
)

for command in "${!apps[@]}"
do
  eval "${apps[command]}"
done

# Edit grub
HEIGHT=10
WIDTH=30
CHOICE_HEIGHT=1
BACKTITLE="Grub configuration"
TITLE="CPU"
MENU="Choose your cpu model:"

OPTIONS=(1 "AMD" 2 "Intel")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amd_iommu=on video=efifb:off"/' /etc/default/grub
            ;;
        2)
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 intel_iommu=on video=efifb:off"/' /etc/default/grub
            ;;
esac

sudo grub-mkconfig -o /boot/grub/grub.cfg

# Install hooks
echo "Installing hooks..."
sudo mkdir /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu

read -r -p "Type VM's name: " input

echo "Installing start and revert scripts..."
sudo mkdir -p /etc/libvirt/hooks/qemu.d/"$input"/prepare/begin
sudo mkdir -p /etc/libvirt/hooks/qemu.d/"$input"/release/end
sudo mv single-gpu-passthrough/start.sh /etc/libvirt/hooks/qemu.d/"$input"/prepare/begin/
sudo mv single-gpu-passthrough/revert.sh /etc/libvirt/hooks/qemu.d/"$input"/release/end
sudo chmod +x /etc/libvirt/hooks/qemu.d/"$input"/prepare/begin/start.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/"$input"/release/end/revert.sh

echo "Adding $username to the kvm and libvirt groups..."
sudo usermod -a -G kvm,libvirt "$username"

echo "Do not forget to add above tweaks to the VM xml through Virtual Machine Manager..."
echo "Press any button to view the xml tweaks..."
read -r -n 1 -s
subl single-gpu-passthrough/xml-editing.txt
