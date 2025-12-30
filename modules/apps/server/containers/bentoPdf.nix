{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.bentoPdf;
in {
  options.servers.containers.bentoPdf = {
    enable = mkEnableOption "Bento PDF";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart BentoPDF";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      bentopdf = {
        image = "bentopdf/bentopdf-simple:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        podman = {
          user = "bentoPdf";
          sdnotify = "healthy";
        };

        networks = [
          "traefik-external"
        ];

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
      users.bentoPdf = {
        isSystemUser = true;
        linger = true;
        group = "bentoPdf";
        home = "/var/lib/bentoPdf";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.bentoPdf = {};
    };
  };
}
