{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.foundry;
in {
  options.servers.containers.foundry = {
    enable = mkEnableOption "Foundry VTT";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Foundry VTT";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.foundryEnv.file = ../../secrets/foundryEnv.age;

    virtualisation.oci-containers.containers = {
      foundry = {
        image = "felddy/foundryvtt:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.foundryEnv.path];

        podman = {
          user = "foundry";
          sdnotify = "healthy";
        };

        volumes = [
          "foundry-data:/data"
        ];

        networks = [
          "traefik-external"
        ];

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.foundry.rule=Host(`foundry.irishtnt.com`)"
          "traefik.http.services.foundry.loadbalancer.server.port=30000"
          "traefik.http.routers.foundry.entrypoints=websecure"
          "traefik.http.routers.foundry.tls.certresolver=external-resolver"
          "traefik.http.routers.foundry.service=foundry"
          "external-service=true"
        ];
      };
    };

    users = {
      users.foundry = {
        isSystemUser = true;
        linger = true;
        group = "foundry";
        home = "/var/lib/foundry";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.foundry = {};
    };
  };
}
