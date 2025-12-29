{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.traefik;
in {
  options.servers.containers.traefik = {
    enable = mkEnableOption "the Traefik container";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Traefik";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      traefik = {
        image = "traefik:v3.6.5";
        privileged = true;
        autoStart = cfg.autoStart;

        podman = {
          user = "traefik";
          sdnotify = "healthy";
        };

        networks = [
          "traefik-external"
        ];

        ports = [
          "80:80"
          "443:443"
        ];

        cmd = [
          "--api.insecure=false"
          "--providers.docker=true"
          "--providers.docker.constraints=Label(`external-service`, `true`)"
          "--providers.docker.exposedbydefault=false"
          "--entryPoints.web.address=:80"
          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entryPoints.web.http.redirections.entrypoint.scheme=https"
          "--entryPoints.websecure.address=:443"
          "--entrypoints.websecure.asDefault=true"
          "--entrypoints.websecure.http.tls.certresolver=external-resolver"
          "--certificatesresolvers.external-resolver.acme.tlschallenge=true"
          "--certificatesresolvers.external-resolver.acme.email=contact@irishtnt.com"
          "--certificatesresolvers.external-resolver.acme.storage=/letsencrypt/acme.json"
          "docker.network=traefik-external"
        ];

        volumes = [
          "letsencrypt:/letsencrypt"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
      };
    };

    users = {
      users.traefik = {
        isSystemUser = true;
        linger = true;
        group = "traefik";
        home = "/var/lib/traefik";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.traefik = {};
    };
  };
}
