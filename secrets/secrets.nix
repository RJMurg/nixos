let
  rjm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKizxhkpIN/7+bQShmOhq8hJLOzRXGhkOGdfgMbCEFcZ";
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQpf9nMOyXwqTQRogphnel0HIK5Eqip8Owzu7xgZ/qO root@nixos";
  users = [ rjm root ];

  daniil = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeLqxshroeY9js/xM/RqL+PDydqwEALHzOv7PrBvdzZ";
  sticky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpJPN19Jelx3yE/P7M3XU5NW0YDHV3RYg89HeqZDQku";
  block = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXjcc3I0/99/Hz96sCAQHolFfbRnIt2h6YkiZCsFGy7";
  systems = [ daniil sticky block ];
in
{
  # NTRJM - Organise these better later
  "rjmPw.age".publicKeys = users ++ systems;
  "forgejoToken.age".publicKeys = [ root sticky block ];
  "registryToken.age".publicKeys = users ++ systems;
  "starboardEnv.age".publicKeys = users ++ systems;
  "gitFile.age".publicKeys = [ root sticky block ];
  "stickyConfig.age".publicKeys = [ root sticky block ];
  # "artemyConfig.age".publicKeys = [ artemy ];
}
