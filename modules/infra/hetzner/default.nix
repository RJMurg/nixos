{ ... }: {
  imports = map (f: ./${f}) (builtins.filter (f: f != "default.nix") (builtins.attrNames (builtins.readDir ./.)));

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Networking
  networking.networkmanager.enable = true;
}