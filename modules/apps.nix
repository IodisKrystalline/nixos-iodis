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
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications."text/plain" = "micro-kitty.desktop";
  };
}