#!/usr/bin/env bash

echo "1. GC Roots"
find ~ -type l -name "result" -exec rm -f {} + 2>/dev/null
sudo find /nix/var/nix/gcroots/auto -mindepth 1 -delete 2>/dev/null

echo "2. Temp"
sudo find /tmp -mindepth 1 -delete 2>/dev/null
sudo find /var/tmp -mindepth 1 -delete 2>/dev/null
sudo find /nix/var/nix/builds -mindepth 1 -delete 2>/dev/null

echo "3. Cache"
sudo find /root/.cache -mindepth 1 -delete 2>/dev/null
[ -d ~/.cache ] && find ~/.cache -mindepth 1 -delete 2>/dev/null
[ -d ~/.cargo ] && find ~/.cargo -mindepth 1 -delete 2>/dev/null
[ -d ~/.npm ] && find ~/.npm -mindepth 1 -delete 2>/dev/null
rm -rf ~/.local/share/Trash/* 2>/dev/null

echo "4. Flatpak & VM"
sudo flatpak uninstall --unused -y 2>/dev/null
sudo flatpak repair 2>/dev/null
[ -d /var/log/libvirt/qemu ] && sudo find /var/log/libvirt/qemu -mindepth 1 -delete 2>/dev/null

echo "5. Journal log"
sudo journalctl --vacuum-time=1s

echo "6. Nix Garbage"
sudo nix-collect-garbage -d
nix-collect-garbage -d

echo "7. Bootloader"
sudo /run/current-system/bin/switch-to-configuration boot

echo "8. Verify & Optimise Nix Store"
sudo nix-store --verify --check-contents --repair
sudo nix-store --optimise

echo "Tuyệt đối sạch sẽ!"