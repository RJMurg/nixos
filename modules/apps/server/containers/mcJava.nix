{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.containers.mcJava;
in {
  options.servers.containers.mcJava = {
    enable = mkEnableOption "Minecraft Java";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Autostart MC Java";
    };

    memory = mkOption {
      type = types.int;
      default = 6;
      description = "The amount of memory to use, in Gigabytes";
    };

    motd = mkOption {
      type = types.str;
      default = "Server again! This time in Docker";
      description = "The MOTD to display in the Servers panel";
    };

    enableRcon = {
      type = types.bool;
      default = false;
      description = "Whether or not to enable the RCON";
    };

    enableBackup = {
      type = types.bool;
      default = true;
      description = "Whether or not to enable a sidecar backup container";
    };

    backupInterval = {
      type = types.str;
      default = "24h";
      description = "The interval between backups";
    };

    retainedDays = {
      type = types.int;
      default = 7;
      description = "The time in days that the backups are retained for";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.mcJava.file = ../../secrets/mcJavaEnv.age;

    virtualisation.oci-containers.containers = {
      mcJava = {
        image = "itzg/minecraft-server:latest";
        privileged = false;
        autoStart = cfg.autoStart;

        environmentFiles = [config.age.secrets.mcJava.path];

        environment = {
          EULA = "true";
          INIT_MEMORY = "${cfg.memory}G";
          MAX_MEMORY = "${cfg.memory}G";
          TZ = "Europe/Dublin";
          USE_AIKAR_FLAGS = true;
          ENABLE_RCON = cfg.enableRcon;
        };

        podman = {
          user = "mcJava";
          sdnotify = "healthy";
        };

        volumes = [
          "/var/lib/mcJava/data:/data"
        ];
      };
    };

    users = {
      users.mcJava = {
        isSystemUser = true;
        linger = true;
        group = "mcJava";
        home = "/var/lib/mcJava";
        createHome = true;
        extraGroups = ["systemd-journal"];
      };

      groups.mcJava = {};
    };

    subConfig = mkIf cfg.enableBackup {
      virtualisation.oci-containers.containers.mcJava.networks = [ "mcJava" ];

      virtualisation.oci-containers.containers = {
        mcJavaBackup = {
          image = "itzg/minecraft-backup:latest";
          privileged = false;
          autoStart = cfg.autoStart;

          environmentFiles = [config.age.secrets.mcJava.path];

          dependsOn = [
            "mcJava"
          ];

          environment = {
            RCON_HOST = "mcJava";
            BACKUP_INTERVAL = "${cfg.backupInterval}";
            PRUNE_BACKUP_DAYS = "${cfg.retainedDays}";
            INITIAL_DELAY = 0;
          };

          podman = {
            user = "mcJavaBackup";
            sdnotify = "healthy";
          };

          volumes = [
            "/var/lib/mcJava/data:/data:ro"
            "/var/lib/mcJavaBackup/backups:/backups:rwo"
          ];
        };
      };

      users = {
        users.mcJavaBackup = {
          isSystemUser = true;
          linger = true;
          group = "mcJavaBackup";
          home = "/var/lib/mcJavaBackup";
          createHome = true;
          extraGroups = ["systemd-journal"];
        };

        groups.mcJava = {};
      };
    };
  };
}
