{ config, pkgs, ... }:

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
    GTK_THEME = "adw-gtk3-dark";
    QT_QPA_PLATFORMTHEME = "qt5ct"; # phủ cả Qt5 lẫn Qt6 (Qt6 app tự fallback dùng qt6ct)
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
    iconTheme.name = "besgnulinux-mono-pink";

    gtk3.extraCss = ''
      @define-color theme_fg_color #FF10F0;
      @define-color theme_text_color #FF10F0;
      @define-color window_fg_color #FF10F0;
      @define-color headerbar_fg_color #FF10F0;
      @define-color sidebar_fg_color #FF10F0;
      @define-color view_fg_color #FF10F0;
      @define-color card_fg_color #FF10F0;
      @define-color popover_fg_color #FF10F0;
      @define-color dialog_fg_color #FF10F0;

      @define-color accent_color #8c1ad7;
      @define-color accent_fg_color #ffffff;
      @define-color accent_bg_color #8c1ad7;

      @define-color theme_selected_bg_color #FF10F0;
      @define-color theme_selected_fg_color #1a1a1a;

      @define-color link_color #ff79c6;
      @define-color link_visited_color #ff79c6;

      @define-color insensitive_fg_color #ff84c2;
      @define-color unfocused_insensitive_color #ff84c2;
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

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.home.homeDirectory}/.config/qt5ct/colors/neonpink.conf
    custom_palette=true
    icon_theme=besgnulinux-mono-pink
    standard_dialogs=default
    style=Fusion

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';

  xdg.configFile."qt5ct/colors/neonpink.conf".text = ''
    [ColorScheme]
    active_colors=#FF10F0, #1B0027, #2A0038, #22002F, #08000C, #170022, #FF10F0, #FFFFFF, #FF10F0, #120019, #120019, #000000, #FF10F0, #120019, #FF6EF9, #8c1ad7, #1B0027, #000000, #1B0027, #FF10F0, #FFB3D9
    inactive_colors=#FF10F0, #1B0027, #2A0038, #22002F, #08000C, #170022, #FF10F0, #FFFFFF, #FF10F0, #120019, #120019, #000000, #8c1ad7, #120019, #FF6EF9, #8c1ad7, #1B0027, #000000, #1B0027, #FF10F0, #FFB3D9
    disabled_colors=#6B5285, #170022, #22002F, #1B0027, #08000C, #120019, #6B5285, #FFFFFF, #6B5285, #120019, #120019, #000000, #4B0082, #6B5285, #6B5285, #6B5285, #170022, #000000, #170022, #6B5285, #6B5285
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/neonpink.conf
    custom_palette=true
    icon_theme=besgnulinux-mono-pink
    standard_dialogs=default
    style=Fusion

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';

  xdg.configFile."qt6ct/colors/neonpink.conf".text = ''
    [ColorScheme]
    active_colors=#FF10F0, #1B0027, #2A0038, #22002F, #08000C, #170022, #FF10F0, #FFFFFF, #FF10F0, #120019, #120019, #000000, #FF10F0, #120019, #FF6EF9, #8c1ad7, #1B0027, #000000, #1B0027, #FF10F0, #FFB3D9
    inactive_colors=#FF10F0, #1B0027, #2A0038, #22002F, #08000C, #170022, #FF10F0, #FFFFFF, #FF10F0, #120019, #120019, #000000, #8c1ad7, #120019, #FF6EF9, #8c1ad7, #1B0027, #000000, #1B0027, #FF10F0, #FFB3D9
    disabled_colors=#6B5285, #170022, #22002F, #1B0027, #08000C, #120019, #6B5285, #FFFFFF, #6B5285, #120019, #120019, #000000, #4B0082, #6B5285, #6B5285, #6B5285, #170022, #000000, #170022, #6B5285, #6B5285
  '';
}