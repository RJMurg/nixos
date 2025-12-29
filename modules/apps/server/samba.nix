{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.servers.samba;
in {
  options.servers.samba = {
    enable = mkEnableOption "the Samba Server Service";

    shareName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "The name of the Samba share.";
    };

    sharePath = mkOption {
      type = types.str;
      default = "/data/Shares/private";
      description = "The path to the Samba share.";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.createSambaShares = ''
      mkdir -p ${cfg.sharePath}
      chown rjm:users ${cfg.sharePath}
      chmod 755 ${cfg.sharePath}
    '';

    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "${cfg.shareName} Samba Server";
          "netbios name" = cfg.shareName;
          "security" = "user";
          "hosts allow" = "192.168.5. 127.";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";

          # MacOS BS
          "vfs objects" = "catia fruit streams_xattr";
          "fruit:metadata" = "stream";
          "fruit:model" = "MacSamba";
          "fruit:posix_rename" = "yes";
          "fruit:veto_appledouble" = "no";
          "fruit:wipe_intentionally_left_blank_rfork" = "yes";
          "fruit:delete_empty_adfiles" = "yes";
        };

        # NTRJM - Make this configurable later
        # NTRJM - Currently have to type `smbpasswd -a rjm` to add user
        # NTRJM - to samba after creating user in nixos config. FIX!!!
        "private" = {
	        # NTRJM - Make this properly be owned by rjm
          "path" = "${cfg.sharePath}";
          "browesable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "rjm";
          "valid users" = "rjm";

	        # More MacOS BS
	        "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    services.avahi = {
      enable = true;
      openFirewall = true;
      publish.enable = true;
      publish.userServices = true;
      nssmdns4 = true;
    };
  };
}
