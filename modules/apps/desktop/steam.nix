{...}: {
  programs.steam = {
    enable = true;

    # I don't need these right now, so I'll add the settings & disable them
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # On the suggestion of the NixOS Wiki
  programs.gamemode.enable = true;
}
