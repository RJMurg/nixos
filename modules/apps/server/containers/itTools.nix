{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.itTools;
in {
  options.servers.containers.itTools = {
    enable = mkEnableOption "IT Tools";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart IT Tools";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      itTools = {
        image = "ghcr.io/sharevb/it-tools:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        podman = {
          user = "itTools";
          sdnotify = "healthy";
        };

        networks = [
          "traefik-external"
        ];

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.ittools.rule=Host(`toolbox.rjm.ie`)"
          "traefik.http.services.ittools.loadbalancer.server.port=8080"
          "traefik.http.routers.ittools.entrypoints=websecure"
          "traefik.http.routers.ittools.tls.certresolver=external-resolver"
          "external-service=true"
        ];
      };
    };

    users = {
      users.itTools = {
        isSystemUser = true;
        linger = true;
        group = "itTools";
        home = "/var/lib/itTools";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.itTools = {};
    };
  };
}
