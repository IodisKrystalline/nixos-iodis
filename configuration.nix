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
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  services = {
    getty.autologinUser = "iodis";
    udisks2.enable = true;
    gvfs.enable = true; # mount USB/ổ đĩa tự động cho Thunar
    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      percentageLow = 25;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff"; # không có swap -> không dùng Hibernate/HybridSleep
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
  security.rtkit.enable = true; # cần cho pipewire quản lý realtime scheduling
  systemd.services."getty@tty1".serviceConfig.Restart = "always";

  security.polkit.enable = true; # cần để udisks2 xin quyền mount ổ đĩa cố định

  # --- QEMU/KVM + virt-manager ---
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    extraConfig = ''
      auth_unix_ro = "none"
      auth_unix_rw = "none"
    ''; # tự kích hoạt card mạng default khi daemon khởi động
  };
  virtualisation.spiceUSBRedirection.enable = true; # redirect USB thật vào VM
  programs.virt-manager.enable = true;

  # --- Hyprland ---
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # --- Fcitx5 (bộ gõ Tiếng Việt) ---
  # Không set GTK_IM_MODULE: Hyprland/Wayland tự dùng text-input-v3, set thêm gây warning thừa.
  # QT_IM_MODULE vẫn cần vì Qt5 chạy qua XWayland.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ qt6Packages.fcitx5-unikey fcitx5-gtk kdePackages.fcitx5-qt ];
  };
  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    # Terminal & shell
    kitty alacritty fish btop fastfetch
    # Terminal toys
    cava cmatrix peaclock terminal-toys snowmachine pipes
    # Editor & dev
    micro vim git wget vscodium
    # Browser & file manager
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    thunar thunar-volman yazi
    # Hyprland ecosystem (bar/wallpaper/lock/idle do caelestia-shell đảm nhiệm)
    uwsm hyprpicker hyprcursor hyprland-qt-support hyprpolkitagent
    # Audio/screenshot/utility
    wireplumber brightnessctl ntfs3g imv mpv wl-clipboard libnotify upower grimblast grim slurp
  ];
  security.pam.services.quickshell = {};

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

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