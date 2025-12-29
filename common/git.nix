{ ... }: {
  programs.git = {
    enable = true;
    package = pkgs.git;

    config = {
      user = {
        name = "Ruán Murgatroyd";
        email = "ruan@murgatroyd.me";
      };
      core.editor = "vim";
    };
  };

  programs.ssh = {
    extraConfig = "
    Host github.com
    HostName github.com
    IdentityFile ~/.ssh/git_key

    Host git.rjm.ie
    HostName git.rjm.ie
    IdentityFile ~/.ssh/git_key
    Port 2222
    ";
  };
}

