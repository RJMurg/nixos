{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.ghost;
in {
  options.servers.containers.ghost = {
    enable = mkEnableOption "Ghost CMS";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Ghost CMS";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.ghostEnv.file = ../../secrets/ghostEnv.age;

    virtualisation.oci-containers.containers = {
      ghost = {
        image = "ghost:6-alpine";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.ghostEnv.path];

        environment = {
          url = "https://blog.rjm.ie";
        }

        podman = {
          user = "ghost";
          sdnotify = "healthy";
        };

        dependsOn = [
          "ghost-db"
        ];

        networks = [
          "traefik-external"
          "ghost"
        ];

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.ghost.rule=Host(`blog.rjm.ie`)"
          "traefik.http.services.ghost.loadbalancer.server.port=2368"
          "traefik.http.routers.ghost.entrypoints=websecure"
          "traefik.http.routers.ghost.tls.certresolver=external-resolver"
          "traefik.docker.network=traefik-external"
          "external-service=true"
        ];
      };

      ghost-db = {
        image = "mysql:8.0";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.ghostEnv.path];

        podman = {
          user = "ghost-db";
          sdnotify = "healthy";
        };

        networks = [
          "ghost"
        ];

        volumes = [
          "data:/var/lib/mysql"
        ];
      };
    };

    users = {
      users.ghost = {
        isSystemUser = true;
        linger = true;
        group = "ghost";
        home = "/var/lib/ghost";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      users.ghost-db = {
        isSystemUser = true;
        linger = true;
        group = "ghost-db";
        home = "/var/lib/ghost-db";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.ghost = {};
      groups.ghost-db = {};
    };
  };
}
