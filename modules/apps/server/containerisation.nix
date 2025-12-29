{...}: {
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
    };

    oci-containers = {
      backend = "podman";
    };
  };

  programs.fish = {
    # NTRJM - Do I need the first two?
    shellInit = ''
      alias vd "vim docker-compose.yml"
      alias dup "docker compose up -d"
      alias dps "docker ps -a"
    '';
  };
}
