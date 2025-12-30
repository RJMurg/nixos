{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.glance;
in {
  options.servers.containers.glance = {
    enable = mkEnableOption "Glance";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Glance";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      glance = {
        image = "glanceapp/glance:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        podman = {
          user = "glance";
          sdnotify = "healthy";
        };

        networks = [
          "traefik-external"
        ];

        # NTRJM - Properly configure the Volumes
        # Docker Socket
        # /app/config
        # /app/assets
        # /etc/localtime

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.bentopdf.rule=Host(`pdf.rjm.ie`)"
          "traefik.http.services.bentopdf.loadbalancer.server.port=8080"
          "traefik.http.routers.bentopdf.entrypoints=websecure"
          "traefik.http.routers.bentopdf.tls.certresolver=external-resolver"
          "traefik.docker.network=traefik-external"
          "external-service=true"
        ];
      };
    };

    users = {
      users.glance = {
        isSystemUser = true;
        linger = true;
        group = "glance";
        home = "/var/lib/glance";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.glance = {};
    };
  };
}
