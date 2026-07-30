{ config, lib, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- Bootloader ---
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    timeout = 5;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = false;
      useOSProber = true;
      theme = pkgs.catppuccin-grub.overrideAttrs (old: {
        postInstall = ''
          ${old.postInstall or ""}
          find $out -type f -name "background.png" -exec cp ${./assets/background.png} {} \;
          find $out -type f -name "logo.png" -delete
          find $out -type f -name "theme.txt" -exec sed -i '/logo/Id' {} \;
        '';
      });
    };
  };
  boot.supportedFilesystems = [ "ntfs" ];

  # --- Networking & Localization ---
  networking.hostName = "iodis-nix";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

  # --- User & Services ---
  users.users.iodis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ tree ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  services = {
    getty.autologinUser = "iodis";
    udisks2.enable = true;
    gvfs.enable = true;   # mount USB/ổ đĩa tự động cho Thunar
    upower.enable = true; # bắt buộc, thiếu sẽ làm caelestia-shell báo lỗi UPower
  };
  systemd.services."getty@tty1".serviceConfig.Restart = "always";

  # --- Hyprland ---
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # --- Fcitx5 (bộ gõ Tiếng Việt) ---
  # Không set GTK_IM_MODULE: Hyprland/Wayland tự dùng text-input-v3, set thêm gây warning thừa
  # QT_IM_MODULE vẫn cần vì Qt5 chạy qua XWayland.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-unikey
      fcitx5-gtk
      kdePackages.fcitx5-qt
    ];
  };
  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    kitty alacritty fish btop fastfetch cava cmatrix peaclock terminal-toys snowmachine
    micro vim vscode-fhs git wget
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    thunar thunar-volman yazi
    uwsm hyprpicker hyprshot hyprcursor hyprland-qt-support # bar/wallpaper/lock/idle do caelestia-shell đảm nhiệm
    wireplumber brightnessctl ntfs3g imv vlc
  ];
  security.pam.services.quickshell = {};

  # --- Nix Config ---
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };
  };

  system.stateVersion = "25.05";
}
