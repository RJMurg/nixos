{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.site;
in {
  options.servers.containers.site = {
    enable = mkEnableOption "RJM Site";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart RJM Site";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.registryToken.file = ../../secrets/registryToken.age;

    virtualisation.oci-containers.containers = {
      site = {
        login = {
          registry = "https://git.rjm.ie";
          username = "rjmurg";
          passwordFile = config.age.secrets.registryToken.path;
        };

        image = "git.rjm.ie/rjmurg/site:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        podman = {
          user = "site";
          sdnotify = "healthy";
        };

        networks = [
          "traefik-external"
        ];

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.rjm.rule=Host(`rjm.ie`)"
          "traefik.http.services.rjm.loadbalancer.server.port=3000"
          "traefik.http.routers.rjm.entrypoints=websecure"
          "traefik.http.routers.rjm.tls.certresolver=external-resolver"
          "traefik.http.middlewares.gnuRequestHeader.headers.customrequestheaders.X-Clacks-Overhead=GNU Graham and Alex"
          "traefik.http.middlewares.gnuResponseHeader.headers.customresponseheaders.X-Clacks-Overhead=GNU Graham and Alex"
          "external-service=true"
        ];
      };
    };

    users = {
      users.site = {
        isSystemUser = true;
        linger = true;
        group = "site";
        home = "/var/lib/site";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.site = {};
    };
  };
}
