# Variables
username=$(whoami)

# Install necessary applications
echo "Installing necessary applications..."
apps=(
"sudo pacman -S qemu"
"sudo pacman -S libvirt"
"sudo pacman -S edk2-ovmf"
"sudo pacman -S virt-manager"
"sudo pacman -S ebtables"
"sudo pacman -S dnsmasq"
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
echo "Editing grub configuration file..."
echo "Add 'amd_iommu=on video=efifb:off' for AMD or 'intel_iommu=on video=efifb:off' for Intel to 'GRUB_CMDLINE_LINUX_DEFAULT='..."
echo "Press any button when you have finished editing the grub configuration file..."
sudo subl /etc/default/grub
read -r -n 1 -s
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