{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.servers.runner;
in {
  options.servers.runner = {
    enable = mkEnableOption "the Forgejo Runner Service";

    runnerName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "The name of the Forgejo runner.";
    };

    runnerCapacity = mkOption {
      type = types.int;
      default = 2;
      description = "The capacity of the runner (number of concurrent jobs).";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.forgejoToken.file = ../../../secrets/forgejoToken.age;

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;

      instances.default = {
        enable = true;
        name = cfg.runnerName;
        url = "https://git.rjm.ie";
        tokenFile = config.age.secrets.forgejoToken.path;
        labels = [
          "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
          "act-runner:docker://node:20-bullseye"
        ];

        settings = {
        container = {
          network = "host";
          privileged = true;
          valid_volumes = [ "**" ];
          docker_host = "automount";
        };
        runner = {
          capacity = cfg.runnerCapacity;
        };
      };
      };
    };

    users.groups.gitea-runner = {};
    users.users.gitea-runner = {
      isSystemUser = true;
      group = "gitea-runner";
      extraGroups = [ "docker" ];
    };
  };
}