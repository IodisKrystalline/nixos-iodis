{ config, pkgs, inputs, ... }:

let
  dotfiles = "/etc/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    uwsm = "uwsm";
    caelestia = "caelestia"; # symlink ra file thật để GUI settings caelestia ghi đè được
    fastfetch = "fastfetch";
  };
in
{
  imports = [
    ./modules/theme.nix
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home.username = "iodis";
  home.homeDirectory = "/home/iodis";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  # --- Fish ---
  programs.fish = {
    enable = true;

    shellAliases = {
      nixos-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#iodis-nix";
      caelestia-neon = "caelestia scheme set -n catppuccin -f mocha -m dark && python3 /etc/nixos/scripts/patch-caelestia-neon.py && sudo nixos-rebuild switch --flake /etc/nixos#iodis-nix";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
      fastfetch

      # Chặn gọi trực tiếp `caelestia scheme set` vì nó ghi đè scheme.json về
      # màu gốc, mất theme neon -> nhắc dùng alias `caelestia-neon` thay thế.
      function caelestia
        if test "$argv[1]" = "scheme" -a "$argv[2]" = "set"
          echo "⚠️  Dùng 'caelestia-neon' thay vì gọi 'scheme set' trực tiếp!"
          echo "Chạy tiếp bằng lệnh gốc? (y/N)"
          read -l confirm
          if test "$confirm" != "y"
            return 1
          end
        end
        command caelestia $argv
      end
    '';

    # Chạy khi đăng nhập TTY1 -> tự kích hoạt Hyprland qua UWSM
    loginShellInit = ''
      if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
          exec uwsm start hyprland-uwsm.desktop
      end
    '';
  };

  programs.kitty = {
    enable = true;
    settings = {
      foreground = "#FF10F0";
      background = "#1a1a1a";
      background_opacity = "0.7";
      cursor = "#FF10F0";
      color0 = "#1a1a1a";  color1 = "#ff5555";  color2 = "#50fa7b";  color3 = "#f1fa8c";
      color4 = "#bd93f9";  color5 = "#ff79c6";  color6 = "#8be9fd";  color7 = "#f8f8f2";
      color8 = "#6272a4";  color9 = "#ff6e6e";  color10 = "#69ff94"; color11 = "#ffffa5";
      color12 = "#d6acff"; color13 = "#ff92df"; color14 = "#a4ffff"; color15 = "#ffffff";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      command_timeout = 2000;
      format = "[](fg:color_bg1)$os$username$hostname[ ](fg:color_bg1 bg:color_bg2)$directory[ ](fg:color_bg2 bg:color_bg3)$git_branch$git_status[ ](fg:color_bg3 bg:color_bg4)$cmd_duration$time[ ](fg:color_bg4)\n$character";
      palette = "neon_cyber";
      palettes.neon_cyber = {
        color_bg1 = "#5E00A3";
        color_bg2 = "#8A2BE2";
        color_bg3 = "#FF10F0";
        color_bg4 = "#2A0038";
        color_text = "#FFFFFF";
        color_err = "#FF0000";
      };
      character = {
        error_symbol = "[❯](bold color_err)";
        success_symbol = "[❯](bold color_bg3)";
      };
      os = {
        disabled = false;
        format = "[$symbol]($style)";
        style = "bg:color_bg1 fg:color_text";
        symbols.NixOS = " ";
      };
      username = {
        disabled = false;
        show_always = true;
        format = "[$user]($style)";
        style_root = "bold bg:color_bg1 fg:color_err";
        style_user = "bold bg:color_bg1 fg:color_text";
      };
      hostname = {
        ssh_only = false;
        format = "[@$hostname]($style)";
        style = "bg:color_bg1 fg:color_text";
      };
      directory = {
        style = "bg:color_bg2 fg:color_text";
        format = "[$path]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };
      git_branch = {
        symbol = "";
        style = "bg:color_bg3 fg:color_text";
        format = "[$symbol $branch]($style)";
      };
      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        deleted = "";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        format = "[( $all_status$ahead_behind)]($style)";
        style = "bold bg:color_bg3 fg:color_text";
      };
      cmd_duration = {
        format = "[ ⏱ $duration ](bg:color_bg4 fg:color_text)";
        min_time = 500;
      };
      time = {
        disabled = false;
        format = "[  $time ](bg:color_bg4 fg:color_text)";
        time_format = "%H:%M";
      };
    };
  };

  # --- Caelestia Shell ---
  # KHÔNG dùng `settings = {...}`: sẽ biến ~/.config/caelestia/shell.json thành
  # symlink chỉ đọc, GUI settings không ghi đè được. Dùng symlink ra file thật
  # ở "configs.caelestia" bên trên thay thế.
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    cli.enable = true;
  };

  home.packages = with pkgs; [
    ripgrep nil nixpkgs-fmt nodejs gcc python3
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [ fzf nix-search-tv ];
      text = ''exec nix-search-tv "$@"'';
    })
  ];

  xdg.configFile = builtins.mapAttrs
    (name: subpath: { source = create_symlink "${dotfiles}/${subpath}"; })
    configs;

  xdg.desktopEntries.micro-kitty = {
    name = "Micro (kitty)";
    genericName = "Text Editor";
    exec = "kitty --title micro -e micro %F";
    terminal = false; # tự bọc kitty trong Exec rồi
    categories = [ "Utility" "TextEditor" ];
    mimeType = [ "text/plain" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications."text/plain" = "micro-kitty.desktop";
  };
}