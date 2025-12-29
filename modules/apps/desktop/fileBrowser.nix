{ ... }: {
  environment.systemPackages = with pkgs.kdePackages; [
    dolphin
    qtsvg # For SVG icons
  ];
}