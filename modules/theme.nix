{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    adwaita-icon-theme
    gnome-themes-extra
    adw-gtk3
    hicolor-icon-theme
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    adwaita-qt
    adwaita-qt6
  ];

  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "15";
    GTK_THEME = "adw-gtk3-dark";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 15;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "besgnulinux-mono-pink";
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 15;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    # ====================== CSS NEON PINK ======================
    gtk3.extraCss = ''
      /* ===== Core text & widgets ===== */
      * {
        color: #FF10F0;
      }

      label, .label, entry, textview, textview text, treeview, 
      .title, .subtitle, .heading, .body, .caption, .caption-heading,
      button, .button, menuitem, .menuitem, 
      list, listview, row, .row,
      notebook, tab, .tab,
      popover, .popover, tooltip, .tooltip,
      sidebar, .sidebar, placessidebar, GtkPlacesSidebar,
      statusbar, .statusbar, GtkStatusbar,
      headerbar, .header-bar, titlebar,
      toolbar, .toolbar,
      frame, .frame,
      scrolledwindow, viewport {
        color: #FF10F0 !important;
      }

      /* Dim / secondary text */
      .dim-label, .caption, .subtitle, entry placeholder, 
      .placeholder, .dim, secondary {
        color: #ff84c2 !important;
      }

      /* Accent / special */
      .accent, statusbar, .success, .warning {
        color: #8c1ad7 !important;
      }

      /* Selection */
      selection, *:selected, row:selected, 
      .view:selected, treeview:selected {
        background-color: #FF10F0 !important;
        color: #1a1a1a !important;
      }

      /* Links */
      link, .link, a {
        color: #ff79c6 !important;
      }

      /* Buttons hover/active */
      button:hover, .button:hover,
      button:active, .button:active,
      button:checked, .button:checked {
        color: #ffffff !important;
        background-color: #ff10f033 !important;
      }

      /* Entry / input focus */
      entry:focus, textview:focus {
        border-color: #FF10F0 !important;
        box-shadow: 0 0 0 1px #FF10F0 !important;
      }

      /* Scrollbar */
      scrollbar slider {
        background-color: #FF10F0 !important;
      }
      scrollbar slider:hover {
        background-color: #ff79c6 !important;
      }
    '';

    gtk4.extraCss = config.gtk.gtk3.extraCss;
    gtk4.theme = config.gtk.theme;
  };

  xdg.configFile."gtk-3.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  xdg.dataFile."icons/besgnulinux-mono-pink".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/assets/besgnulinux-mono-pink";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "besgnulinux-mono-pink";
      cursor-theme = "Adwaita";
      cursor-size = 15;
    };
  };
}