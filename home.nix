{ config, pkgs, inputs, ... }:

let
  dotfiles = "/etc/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    uwsm = "uwsm";
    caelestia = "caelestia"; # symlink ra file thật để GUI settings caelestia ghi đè được
    fastfetch = "fastfetch";
    micro = "micro";
    yazi = "yazi";
    cava = "cava";
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

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # --- Fish ---
  programs.fish = {
    enable = true;

    shellAliases = {
      nixos-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#iodis-nix";
      caelestia-neon = "caelestia scheme set -n dracula -m dark && python3 /etc/nixos/scripts/patch-caelestia-neon.py && sudo nixos-rebuild switch --flake /etc/nixos#iodis-nix";
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
      background_opacity = "0.5";
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
      add_newline = false;
      continuation_prompt = "[▸▹ ](dimmed white)";

      format = "($nix_shell$fill$git_metrics\n)$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character";
      right_format = "$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$custom$status$os$battery$time";

      fill.symbol = " ";

      character = {
        format = "$symbol ";
        success_symbol = "[◎](bold italic bright-yellow)";
        error_symbol = "[○](italic purple)";
        vimcmd_symbol = "[■](italic dimmed green)";
        vimcmd_replace_one_symbol = "◌";
        vimcmd_replace_symbol = "□";
        vimcmd_visual_symbol = "▼";
      };

      env_var.VIMSHELL = {
        format = "[$env_value]($style)";
        style = "green italic";
      };

      sudo = {
        format = "[$symbol]($style)";
        style = "bold italic bright-purple";
        symbol = "⋈┈";
        disabled = false;
      };

      username = {
        style_user = "bright-yellow bold italic";
        style_root = "purple bold italic";
        format = "[⭘ $user]($style) ";
        disabled = false;
        show_always = false;
      };

      directory = {
        home_symbol = "⌂";
        truncation_length = 2;
        truncation_symbol = "□ ";
        read_only = " ◈";
        use_os_path_sep = true;
        style = "italic blue";
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold blue";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)";
      };

      cmd_duration = {
        min_time = 0;
        format = "[◄ $duration ](italic white)";
      };

      jobs = {
        format = "[$symbol$number]($style) ";
        style = "white";
        symbol = "[▶](blue italic)";
      };

      localip = {
        ssh_only = true;
        format = " ◯[$localipv4](bold magenta)";
        disabled = false;
      };

      time = {
        disabled = false;
        format = "[ $time]($style)";
        time_format = "%R";
        utc_time_offset = "local";
        style = "italic dimmed white";
      };

      battery = {
        format = "[ $percentage $symbol]($style)";
        full_symbol = "█";
        charging_symbol = "[↑](italic bold green)";
        discharging_symbol = "↓";
        unknown_symbol = "░";
        empty_symbol = "▃";
        display = [
          { threshold = 20; style = "italic bold red"; }
          { threshold = 60; style = "italic dimmed bright-purple"; }
          { threshold = 70; style = "italic dimmed yellow"; }
        ];
      };

      git_branch = {
        format = " [$branch(:$remote_branch)]($style)";
        symbol = "[△](bold italic bright-blue)";
        style = "italic bright-blue";
        truncation_symbol = "⋯";
        truncation_length = 11;
        ignore_branches = [ "main" "master" ];
        only_attached = true;
      };

      git_metrics = {
        format = "([▴\$added]($added_style))([▿\$deleted]($deleted_style))";
        added_style = "italic dimmed green";
        deleted_style = "italic dimmed red";
        ignore_submodules = true;
        disabled = false;
      };

      git_status = {
        style = "bold italic bright-blue";
        format = "([⎪\$ahead_behind\$staged\$modified\$untracked\$renamed\$deleted\$conflicted\$stashed⎥]($style))";
        conflicted = "[◪◦](italic bright-magenta)";
        ahead = "[▴│[\${count}](bold white)│](italic green)";
        behind = "[▿│[\${count}](bold white)│](italic red)";
        diverged = "[◇ ▴┤[\${ahead_count}](regular white)│▿┤[\${behind_count}](regular white)│](italic bright-magenta)";
        untracked = "[◌◦](italic bright-yellow)";
        stashed = "[◃◈](italic white)";
        modified = "[●◦](italic yellow)";
        staged = "[▪┤[\$count](bold white)│](italic bright-cyan)";
        renamed = "[◎◦](italic bright-blue)";
        deleted = "[✕](italic red)";
      };

      nix_shell = {
        style = "bold italic dimmed blue";
        symbol = "✶";
        format = "[\$symbol nix⎪\$state⎪]($style) [\$name](italic dimmed white)";
        impure_msg = "[⌽](bold dimmed red)";
        pure_msg = "[⌾](bold dimmed green)";
        unknown_msg = "[◌](bold dimmed yellow)";
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

  # --- Battery nag (nhắc pin yếu lặp lại tới khi cắm sạc) ---
  systemd.user.services.battery-nag = {
    Unit = {
      Description = "Nhắc cắm sạc khi pin yếu";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/etc/nixos/scripts/battery-nag.sh";
    };
  };

  systemd.user.timers.battery-nag = {
    Unit.Description = "Timer cho battery-nag";
    Timer = {
      OnStartupSec = "10s";
      OnUnitActiveSec = "10s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
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