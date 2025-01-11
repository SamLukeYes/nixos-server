{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    archix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/archix";
    };

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
  };

  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs: 
  let
    system = "x86_64-linux";
    channel-patches = [
      # Add nixpkgs patches here
      ./patches/359365.patch
    ];

  in flake-utils-plus.lib.mkFlake rec {
    inherit self inputs;
    supportedSystems = [ system ];

    channels = {
      nixos-unstable = {
        input = nixpkgs;
        patches = channel-patches;
      };
    };

    hostDefaults = {
      inherit system;
      channelName = "nixos-unstable";

      modules = [
        {
          nix = {
            generateNixPathFromInputs = true;
            generateRegistryFromInputs = true;
            linkInputs = true;
          };
        }

        inputs.archix.nixosModules.default
        ./programs/pacman.nix

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }

        ./common.nix
      ];
    };

    hosts = {
      azure.modules = [
        ./machines/azure.nix
      ];
    };

    nixosModules.synced = import ./services/synced;
  };
}