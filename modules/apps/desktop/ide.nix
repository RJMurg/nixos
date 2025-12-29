{ ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # NTRJM - Look into bug that doesn't let these initialise
      github.copilot-chat
      github.copilot
      ms-azuretools.vscode-containers
      docker.docker
      ms-azuretools.vscode-docker
      k--kato.intellij-idea-keybindings
      james-yu.latex-workshop
      tecosaur.latex-utilities
      pkief.material-icon-theme
      emroussel.atomize-atom-one-dark-theme
      johnpapa.vscode-peacock
      esbenp.prettier-vscode
      prisma.prisma
      ms-python.python
      ms-python.debugpy
      ms-python.vscode-pylance
      ms-vscode.remote-explorer
      ms-vscode-remote.remote-ssh
      svelte.svelte-vscode
      myriad-dreamin.tinymist
      streetsidesoftware.code-spell-checker
    ];
  };
}