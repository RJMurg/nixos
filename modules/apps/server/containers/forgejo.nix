{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.forgejo;
in {
  options.servers.containers.forgejo = {
    enable = mkEnableOption "Forgejo";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart Forgejo";
    };
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers = {
      forgejo = {
        image = "codeberg.org/forgejo/forgejo:13.0.3";
        privileged = false;
        autoStart = cfg.autoStart;

        podman = {
          user = "git";
          sdnotify = "healthy";
        };

        environment = {
          USER_UID = "1000";
          USER_GID = "1000";
          FORGEJO__database_DB_TYPE = "sqlite3";
          FORGEJO_REPOSITORY__DISABLE_STARS = "true";
          FORGEJO__server__ROOT_URL = "https://git.rjm.ie";
          FORGEJO__server__SSH_CREATE_AUTHORIZED_KEYS_FILE = "false";
          FORGEJO__service__DISABLE_REGISTRATION = "true";
        };

        extraOptions = [
          "--health-cmd=curl -f http://127.0.0.1:3000/api/healthz || exit 1"
          "--health-interval=15s"
          "--health-timeout=3s"
          "--health-retries=3"
          "--health-on-failure=kill"
        ];

        volumes = [
          "forgejo-data:/data"
        ];

        networks = [
          "traefik-external"
        ];

        labels = [
          "traefik.enable=true"
          "traefik.http.routers.forgejo.rule=Host(`git.rjm.ie`)"
          "traefik.http.services.forgejo.loadbalancer.server.port=3000"
          "traefik.http.routers.forgejo.entrypoints=websecure"
          "traefik.http.routers.forgejo.tls.certresolver=external-resolver"
          "traefik.docker.network=traefik-external"
          "external-service=true"
        ];
      };
    };

    # Just doing whatever Magic Hari did
    # https://tangled.org/haripm.com/seafoam/blob/main/hosts/verdigris/containers/forgejo.nix
    services.openssh.extraConfig = ''
      Match User git
        AuthorizedKeysCommand /etc/ssh/git-authorised-keys %u %t %k
        AuthorizedKeysCommandUser git
    '';

    environment.etc ={
      "ssh/git-authorised-keys" = {
        text = ''
          #!/bin/sh
          /run/current-system/sw/bin/podman exec \
          --interactive \
          -- user git \
          forgejo /usr/local/bin/forgejo \
          -- config /data/gitea/conf/app.ini \
          keys -e git -u "$1" -t "$2" -k "$3"
        '';
        mode = "";
      };
    };

    systemd.tmpfiles.rules = [
      "L+ /var/lib/git/git-shell 0750 git git - ${pkgs.writeShellScript "git-shell" ''
        #!/bin/sh
        /run/current-system/sw/bin/podman exec \
          --interactive \
          --user git \
          --env SSH_ORIGINAL_COMMAND="$SSH_ORIGINAL_COMMAND" \
          forgejo \
          sh "$@"
      ''}"
    ];

    users = {
      users.git = {
        isSystemUser = true;
        linger = true;
        group = "git";
        home = "/var/lib/git";
        createHome = true;
        autoSubUidGidRange = true;
        extraGroups = ["systemd-journal"];
        shell = "/var/lib/git/git-shell";
      };

      groups.git = {};
    };
  };
}
