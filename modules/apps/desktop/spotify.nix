{pkgs, ...}: {
  # NTRJM - Consider moving to Spotifyd?

  environment.systemPackages = with pkgs; [
    spotify
  ];

  # Allow syncing local tracks
  networking.firewall.allowedTCPPorts = [57621];
}
