{ ... }: {
  environment.systemPackages = with pkgs.kdePackages; [
    partitionmanager
  ];
}