{ pkgs, ... }:

{  
  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    cli.enable = true;
  };
  
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  programs.git = {
    enable = true;
    settings.user.name = "iodis";
    settings.user.email = "iodis@example.com";
  };

  xdg.desktopEntries = {
    micro-kitty = {
      name = "Micro (kitty)";
      genericName = "Text Editor";
      exec = "kitty --title micro -e micro %F";
      terminal = false;
      categories = [ "Utility" "TextEditor" ];
      mimeType = [ "text/plain" ];
    };
    prismlauncher = {
      name = "Prism Launcher";
      genericName = "Minecraft";
      exec = "appimage-run /home/iodis/Downloads/PrismLauncher.AppImage";
      terminal = false;
      categories = [ "Game" ];
    };
    vi-ime = {
      name = "vi-ime";
      genericName = "Vietnamese Input Method";
      exec = "appimage-run /home/iodis/Downloads/vi-ime-7.3.5-x86_64.AppImage";
      terminal = false;
      categories = [ "Utility" ];
    };
  };
  home.packages = [ pkgs.libayatana-appindicator ];
  home.sessionVariables.LD_LIBRARY_PATH =
    "${pkgs.libayatana-appindicator}/lib:$LD_LIBRARY_PATH";

  xdg.mimeApps = {
    enable = true;
    defaultApplications."text/plain" = "micro-kitty.desktop";
  };
}