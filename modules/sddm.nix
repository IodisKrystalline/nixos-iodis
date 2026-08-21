{ config, pkgs, ... }:

let
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    themeConfig = {
      HeaderTextColor = "#ff00aa";
      Background = "Backgrounds/your-custom-background.png";
      PartialBlur = "true";
      BlurMax = "25";
      Blur = "1.0";
    };
  }).overrideAttrs (old: {
    installPhase = old.installPhase + ''
      chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
      cp ${../assets/background.png} \
        $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/your-custom-background.png
    '';
  });
in

{
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qt5compat
      kdePackages.qtsvg
      kdePackages.qtwayland
      adwaita-icon-theme
    ];
    wayland.enable = true;
    
    settings = {
      General.InputMethod = "";
      Theme = {
        CursorTheme = "Adwaita";
        CursorSize = 15;
        Background = "/etc/nixos/assets/background.png";
      };
    };
  };
  environment.systemPackages = with pkgs; [ 
      sddm-astronaut
    ];
}