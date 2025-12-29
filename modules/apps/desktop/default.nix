{ ... }: {
  imports = map (f: ./${f}) (builtins.filter (f: f != "default.nix") (builtins.attrNames (builtins.readDir ./.)));

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}