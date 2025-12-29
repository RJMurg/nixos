{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInit = ''
      alias rebuild "sudo nixos-rebuild switch --flake /etc/nixos/.#(hostname)"
      alias nixconfig "cd /etc/nixos"
      alias where which
      alias agedit "nix run github:ryantm/agenix -- --identity /etc/ssh/ssh_host_ed25519_key -e"
    '';
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  users.extraUsers.rjm = {
    shell = pkgs.fish;
  };
}