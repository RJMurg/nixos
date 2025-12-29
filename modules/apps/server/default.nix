{ ... }: {
  imports = map (f: ./${f}) (builtins.filter (f: f != "default.nix") (builtins.attrNames (builtins.readDir ./.)));

  # WireGuard
  age.secrets.stickyConfig.file = "/etc/nixos/secrets/${config.networking.hostName}Config.age";
  networking.wg-quick.interfaces.opusNet.configFile = config.age.secrets.stickyConfig.path;

  age.secrets.gitKey = {
    file = /etc/nixos/secrets/gitFile.age;
    path = "/home/rjm/.ssh/git_key";
    owner = "rjm";
    group = "users";
    mode = "600";
  };
}