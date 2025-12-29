{ ... }: {
  systemd.timers."garbage-day" = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 03:00";
      Persistent = true; # Runs if it missed the last occurence. Allows Daniil to be powered off.

      Unit = "clear-garbage.service";
    };
  };

  systemd.services."clear-garbage" = {
    script = ''
      set -eu
      nix-collect-garbage
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}