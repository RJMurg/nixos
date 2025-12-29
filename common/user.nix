{ config, ... }: {
  age.secrets.rjmPw.file = ./secrets/rjmPw.age;

  users.users.rjm = {
    isNormalUser = true;
    description = "Ruán Murgatroyd";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIojxY5p2HAmlJP6A9rHJkgU/oXPmGQDKVqQHOck7JtW I748363@LC14W0R045"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBx7zZvv7ejMQ0C2buVOoySDfC/ToEaHgtkKbxluXmL rjm@daniil"
    ];
    hashedPasswordFile = config.age.secrets.rjmPw.path;
  };
}
