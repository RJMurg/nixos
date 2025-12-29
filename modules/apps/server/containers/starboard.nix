{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.starboard;
in {
  options.servers.containers.starboard = {
    enable = mkEnableOption "Starboard";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Starboard";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.registryToken.file = ../../secrets/registryToken.age;
    age.secrets.starboardEnv.file = ../../secrets/starboardEnv.age;

    virtualisation.oci-containers.containers = {
      starboard = {
        login = {
          registry = "https://git.rjm.ie";
          username = "rjmurg";
          passwordFile = config.age.secrets.registryToken.path;
        };

        image = "git.rjm.ie/rjmurg/friendconstellation:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.starboardEnv.path];

        podman = {
          user = "starboard";
          sdnotify = "healthy";
        };

        dependsOn = [
          "starboard-db"
        ];

        networks = [
          "traefik-external"
          "starboard"
        ];

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.starboard.rule=Host(`stars.rjm.ie`)"
          "traefik.http.services.starboard.loadbalancer.server.port=3000"
          "traefik.http.routers.starboard.entrypoints=websecure"
          "traefik.http.routers.starboard.tls.certresolver=external-resolver"
          "traefik.docker.network=traefik-external"
          "external-service=true"
        ];
      };

      starboard-db = {
        image = "postgres:18-alpine";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.starboardEnv.path];

        podman = {
          user = "starboard-db";
          sdnotify = "healthy";
        };

        networks = [
          "starboard"
        ];

        volumes = [
          "pg-data:/var/lib/postgresql/data"
        ];
      };
    };

    users = {
      users.starboard-db = {
        isSystemUser = true;
        linger = true;
        group = "starboard-db";
        home = "/var/lib/starboard-db";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.starboard-db = {};
    };
  };
}
