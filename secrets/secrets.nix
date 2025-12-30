let
  rjm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKizxhkpIN/7+bQShmOhq8hJLOzRXGhkOGdfgMbCEFcZ";
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQpf9nMOyXwqTQRogphnel0HIK5Eqip8Owzu7xgZ/qO root@nixos";
  users = [rjm root];

  daniil = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeLqxshroeY9js/xM/RqL+PDydqwEALHzOv7PrBvdzZ";
  sticky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpJPN19Jelx3yE/P7M3XU5NW0YDHV3RYg89HeqZDQku";
  block = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXjcc3I0/99/Hz96sCAQHolFfbRnIt2h6YkiZCsFGy7";
  systems = [daniil sticky block];
in {
  # NTRJM - Organise these better later

  # Common Secrets
  "rjmPw.age".publicKeys = users ++ systems;
  "gitFile.age".publicKeys = [root sticky block];
  
  # WG Secrets
  "stickyConfig.age".publicKeys = [root sticky block];
  # "artemyConfig.age".publicKeys = [ artemy ];
  
  # Container Envs
  "registryToken.age".publicKeys = users ++ systems;
  "starboardEnv.age".publicKeys = users ++ systems;
  "foundryEnv.age".publicKeys = users ++ systems;
  "ghostEnv.age".publicKeys = users ++ systems;
  "grabengineEnv.age".publicKeys = users ++ systems;

  # Service Secrets
  "forgejoToken.age".publicKeys = [root sticky block];
}
