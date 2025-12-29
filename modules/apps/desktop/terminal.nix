{pkgs, ...}: {
  # NTRJM - Get something more customisable?
  environment.systemPackages = with pkgs; [
    alacritty
  ];
}
