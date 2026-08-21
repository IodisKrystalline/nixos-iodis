{ config, lib, pkgs, inputs, ... }:

let
  dotfiles = "/etc/nixos/config";
  dotfileNames = [ "hypr" "uwsm" "caelestia" "fastfetch" "micro" "yazi" "cava" "niri" "noctalia" ];
in
{
  imports = [
    ./modules/theme.nix
    ./modules/terminal.nix
    ./modules/apps.nix
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home.username = "iodis";
  home.homeDirectory = "/home/iodis";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [ nil nixpkgs-fmt ripgrep python3 appimage-run ];
  home.activation.cleanBrokenSymlinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    $DRY_RUN_CMD find "$HOME/.config" -xtype l -delete 2>/dev/null || true
  '';

  xdg.configFile = lib.genAttrs dotfileNames (name: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  });
}