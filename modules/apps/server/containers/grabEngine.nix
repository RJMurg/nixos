{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.grabEngine;
in {
  options.servers.containers.grabEngine = {
    enable = mkEnableOption "Grab Engine";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Grab Engine";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.grabengineEnv.file = ../../secrets/grabengineEnv.age;

    virtualisation.oci-containers.containers = {
      grabengine = {
        image = "ghcr.io/rjmurg/grabengine:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.grabengineEnv.path];

        podman = {
          user = "grabengine";
          sdnotify = "healthy";
        };

        dependsOn = [
          "grabengine-db"
        ];

        networks = [
          "traefik-external"
          "grabengine"
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

      grabengine-db = {
        image = "postgres:18-alpine";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.grabengineEnv.path];

        podman = {
          user = "grabengine-db";
          sdnotify = "healthy";
        };

        networks = [
          "grabengine"
        ];

        volumes = [
          "pg-data:/var/lib/postgresql/data"
        ];
      };
    };

    users = {
      users.grabengine = {
        isSystemUser = true;
        linger = true;
        group = "grabengine";
        home = "/var/lib/grabengine";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      users.grabengine-db = {
        isSystemUser = true;
        linger = true;
        group = "grabengine-db";
        home = "/var/lib/grabengine-db";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.grabengine = {};
      groups.grabengine-db = {};
    };
  };
}
