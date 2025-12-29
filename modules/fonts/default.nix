{
  pkgs,
  config,
  ...
}: {
  fonts.packages = with pkgs; [
    montserrat
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
}
