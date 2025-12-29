{
  description = "Flake for all my machines";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
  };

  outputs = { self, nixpkgs, disko, agenix } @ inputs: let
    lib = nixpkgs.lib;
    createSystem = {
      host,
      type,
      optionalModules
    }:
      lib.nixosSystem {
        specialArgs = { inherit ( inputs ) self; };
        modules = [
          ./systems/${host}
        ] ++ optionalModules;
      };

  in {
    nixosConfigurations = {

      # ---
      # PCs
      # ---
      daniil = createSystem {
        host = "daniil";
        type = "pc";
        optionalModules = [
          agenix.nixosModules.default
          # NTRJM - Add Disko when I finally write the config
        ];
      };

      # -------
      # Servers
      # -------

      sticky = createSystem {
        host = "sticky";
        type = "server";
        optionalModules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };

      artemy = createSystem {
        host = "artemy";
        type = "server";
        optionalModules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };

      block = createSystem {
        host = "block";
        type = "server";
        optionalModules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };
    }
  }
}