{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    activitywatch
  ];
}