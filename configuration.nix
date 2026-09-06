{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/sddm.nix
  ];

  # --- Boot ---
  boot = { 
    loader = {
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
  };
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # --- Networking & Localization ---
  networking.hostName = "iodis-nix";
  networking.networkmanager.enable = true;
  systemd.services.ModemManager.enable = false;
  time.timeZone = "Asia/Ho_Chi_Minh";

  # --- Users & Shell ---
  users.users.iodis = {
    isNormalUser = true;
    extraGroups = [ "wheel" "gamemode" "libvirtd" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # --- Core Services ---
  services = {
    getty.autologinUser = "iodis";
    udisks2.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      percentageLow = 25;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    xserver.enable = lib.mkForce false;
    thermald.enable = true;
    flatpak.enable = true;
    cloudflare-warp.enable = true;
    logind.settings.Login.KillUserProcesses = true;
  };
  systemd.services = {
    cloudflare-warp.wantedBy = lib.mkForce [ ];
    libvirtd.wantedBy = lib.mkForce [ ];
  };
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # --- Bluetooth ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # --- Virtualization ---
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    extraConfig = ''
      auth_unix_ro = "none"
      auth_unix_rw = "none"
    '';
  };
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  # --- Hyprland & Niri ---
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.niri.enable = true;

  # --- Gaming & Graphics ---
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver vpl-gpu-rt ];
  };
  programs.gamemode.enable = true;

  # --- Input Method (Fcitx5) ---
  i18n.inputMethod = {
    enable = false;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ qt6Packages.fcitx5-unikey fcitx5-gtk kdePackages.fcitx5-qt ];
  };
#  environment.sessionVariables = {
#    QT_IM_MODULE = "fcitx";
#    XMODIFIERS = "@im=fcitx";
#  };
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # --- File Manager ---
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  environment.systemPackages = with pkgs; [
    # Terminal & tools
    alacritty btop fastfetch ttyper
    cava cmatrix peaclock terminal-toys snowmachine pipes
    # Editors & dev
    micro git wget vscodium
    # Browser & file manager
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    yazi
    # Hyprland & Niri ecosystem
    uwsm hyprland-qt-support hyprpolkitagent
    noctalia-shell
    # Utils
    wireplumber brightnessctl ntfs3g imv mpv wl-clipboard
    libnotify upower grimblast cloudflare-warp file-roller unzip
  ];

  # --- Nix ---
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
