#!/usr/bin/env bash
set -uo pipefail

echo
echo "1. GC roots"
find ~ -maxdepth 3 -type l -name "result*" -delete 2>/dev/null
sudo find /etc/nixos -maxdepth 2 -type l -name "result*" -delete 2>/dev/null
sudo find /nix/var/nix/gcroots -xtype l -delete 2>/dev/null

echo
echo "2. Temp files"
sudo systemd-tmpfiles --clean

echo
echo "3. Cache"
find ~/.cache -mindepth 1 -maxdepth 1 \
    ! -name "mesa_shader_cache" \
    ! -name "fontconfig" \
    ! -name "nix" \
    -exec rm -rf {} + 2>/dev/null
rm -rf ~/.cache/thumbnails/* 2>/dev/null
[ -d ~/.cargo/registry ] && rm -rf ~/.cargo/registry/cache/* 2>/dev/null
[ -d ~/.npm ] && npm cache clean --force 2>/dev/null
rm -rf ~/.local/share/Trash/* 2>/dev/null
sudo rm -rf /root/.cache/* 2>/dev/null

echo
echo "4. Flatpak & VM logs"
flatpak uninstall --unused -y 2>/dev/null
flatpak repair 2>/dev/null
sudo find /var/log/libvirt/qemu -mindepth 1 -delete 2>/dev/null

echo
echo "5. Journal"
sudo journalctl --vacuum-time=1weeks

echo
echo "6. Nix garbage"
sudo nix-collect-garbage -d
nix-collect-garbage -d
sudo nix-store --gc

echo
echo "7. Optimise store"
sudo nix-store --optimise

echo
echo "8. Nix store"
du -sh /nix/store/*/ 2>/dev/null | sort -rh | head -10
sudo nix store verify --all

echo
echo "Bonus"
echo "sudo nix-store --verify --check-contents --repair"

echo
echo "TUYỆT ĐỐI SẠCH SẼ!"