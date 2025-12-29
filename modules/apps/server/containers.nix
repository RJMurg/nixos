{ ... }: {
  virtualisation.docker = {
    enable = true;
  };

  users.users.rjm.extraGroups = [ "docker" ];

  programs.fish = {
    shellInit = ''
      alias vd "vim docker-compose.yml"
      alias dup "docker compose up -d"
      alias dps "docker ps -a"
    '';
  };
}