{ ... }: {
  environment.systemPackages = with pkgs; [
    whatsapp-electron
  ];
}