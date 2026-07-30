{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    glib
    adwaita-icon-theme
    gnome-themes-extra
    gtk-engine-murrine

    (catppuccin-gtk.override {
      accents = [ "pink" ];
      variant = "mocha";
    })
  ];

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-pink-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "mocha";
      };
    };

    iconTheme.name = "besgnulinux-mono-pink"; # phải khớp Y HỆT dòng Name= trong index.theme

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
    gtk4.theme = config.gtk.theme;

    gtk3.extraCss = ''
      /* Text chinh: Neon Pink */
      label, entry, textview text, treeview, .title, .subtitle {
        color: #FF10F0;
      }
      /* Text phu 1: Pastel Pink (nhan mo, placeholder, caption) */
      .dim-label, .caption, entry placeholder, GtkPlacesSidebar {
        color: #FFB3D9;
      }
      /* Text phu 2: Pastel Purple (status bar, badge, accent phu) */
      statusbar, .accent, GtkStatusbar {
        color: #C9A0FF;
      }
    '';
    gtk4.extraCss = config.gtk.gtk3.extraCss;
  };

  xdg.configFile."gtk-3.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  xdg.dataFile."icons/besgnulinux-mono-pink".source =
  config.lib.file.mkOutOfStoreSymlink "/etc/nixos/assets/besgnulinux-mono-pink";

  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };
}