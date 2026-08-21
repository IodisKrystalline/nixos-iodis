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

  westonIni = (pkgs.formats.ini { }).generate "weston.ini" {
    libinput = {
      enable-tap = config.services.libinput.mouse.tapping;
      left-handed = config.services.libinput.mouse.leftHanded;
    };
    keyboard.keymap_layout = "us";
    shell = {
      cursor-theme = "Adwaita";
      cursor-size = 24;
    };
  };
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
    wayland = {
      enable = true;
      # weston kiosk thay vì compositor mặc định: astronaut-theme cần cursor
      # theme tường minh (Adwaita), mặc định greeter Wayland không tự hiện
      # cursor -> đây là fix, không phải tuỳ chọn thẩm mỹ.
      compositorCommand =
        "env XCURSOR_THEME=Adwaita XCURSOR_SIZE=24 XCURSOR_PATH=/run/current-system/sw/share/icons "
        + "${pkgs.weston}/bin/weston --shell=kiosk -c ${westonIni}";
    };
    settings = {
      General.InputMethod = "";
      Theme = {
        CursorTheme = "Adwaita";
        CursorSize = 24;
        Background = "/etc/nixos/assets/background.png";
      };
    };
  };
}
