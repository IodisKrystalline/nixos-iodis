{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    adwaita-icon-theme
    gnome-themes-extra
    gtk-engine-murrine
    hicolor-icon-theme
  ];
  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "15";
  };
  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 15;
  };

  gtk = {
    enable = true;
    theme.name = "Dracula";
    theme.package = pkgs.dracula-theme;
    iconTheme.name = "besgnulinux-mono-pink";
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 15;
    };
    gtk4.theme = config.gtk.theme;

    gtk3.extraCss = ''
      label, entry, textview text, treeview, .title, .subtitle { color: #FF10F0; }
      .dim-label, .caption, entry placeholder, GtkPlacesSidebar { color: #ff84c2; }
      statusbar, .accent, GtkStatusbar { color: #8c1ad7; }
    '';
    gtk4.extraCss = config.gtk.gtk3.extraCss;
  };

  xdg.configFile."gtk-3.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  xdg.dataFile."icons/besgnulinux-mono-pink".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/assets/besgnulinux-mono-pink";
}