{ ... }: {
  services.xserver.enable = true;

  # KDE Plasma DE
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable numlock lol
  services.displayManager.sddm.autoNumlock = true;

  services.xserver.xkb = {
    layout = "ie";
    variant = "";
  };

  # Hyprland
  # NTRJM - I am keeping KDE *and* Hyprland here just for the time being.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  # Because Hyprland is so bare-bones, I'll include the remaining hyprsystem stuff here
  environment.systemPackages = [
    pkgs.hyprpicker
    pkgs.hyprlauncher
    pkgs.hypridle
    pkgs.hyprlock
    pkgs.hyprpolkitagent
    pkgs.hyprland-qt-support
    pkgs.hyprpwcenter

    # NTRJM - Vaxry, I fucking hate you. Why is this not on NixOS yet?
    #         Come the fuck on I am NEVER building this from source.
    # pkgs.hyprshutdown
    pkgs.hyprviz
  ];
}