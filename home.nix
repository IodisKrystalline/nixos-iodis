{ config, lib, pkgs, inputs, ... }:

let
  dotfiles = "/etc/nixos/config";
  dotfileNames = [ "hypr" "uwsm" "caelestia" "fastfetch" "micro" "yazi" "cava" "niri" "noctalia" ];
in
{
  imports = [
    ./modules/theme.nix
    ./modules/terminal.nix
    ./modules/battery.nix
    ./modules/apps.nix
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home.username = "iodis";
  home.homeDirectory = "/home/iodis";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [ ripgrep nil nixpkgs-fmt python3 tree appimage-run ];
  home.activation.cleanBrokenSymlinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    $DRY_RUN_CMD find "$HOME/.config" -xtype l -delete 2>/dev/null || true
  '';

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xdg.configFile = lib.genAttrs dotfileNames (name: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  });

  # --- Shell ---
  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    cli.enable = true;
  };
}