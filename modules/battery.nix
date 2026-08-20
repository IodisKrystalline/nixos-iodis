{ ... }:

{
  systemd.user.services.battery-nag = {
    Unit.Description = "Pin yếu";
    Unit.After = [ "default.target" ]; # chạy chung mọi session (Hyprland lẫn Niri)
    Service = {
      Type = "oneshot";
      ExecStart = "/etc/nixos/scripts/battery-nag.sh";
    };
  };

  systemd.user.timers.battery-nag = {
    Unit.Description = "Timer cho battery-nag";
    Timer.OnStartupSec = "30s";
    Timer.OnUnitActiveSec = "30s";
    Install.WantedBy = [ "default.target" ];
  };
}
