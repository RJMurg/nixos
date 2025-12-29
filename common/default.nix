{pkgs, ...}: {
  imports = map (f: ./${f}) (builtins.filter (f: f != "default.nix") (builtins.attrNames (builtins.readDir ./.)));

  # NixOS Version
  system.stateVersion = "25.05";

  # Kernel - Staying on 16.17
  boot.kernelPackages = pkgs.linuxPackages_6_17;
  nixpkgs.config.allowUnfree = true;

  # Disable sudo password
  security.sudo.wheelNeedsPassword = false;

  # Support Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    download-buffer-size = 524288000;
  };

  # Timezoning
  time.timeZone = "Europe/Dublin";

  # Console Keymapping
  console.keyMap = "ie";

  # CUPS document printing
  services.printing.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # ----------
  # SSH Server
  # ----------

  # OpenSSH Server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["rjm"];
    };
  };

  # Enable Fail2Ban
  services.fail2ban = {
    enable = true;
    # NTRJM - Add more stuff
  };
}
