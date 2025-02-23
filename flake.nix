{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    archix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/archix";
    };

    deploy-rs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:serokell/deploy-rs";
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
    ];

  in flake-utils-plus.lib.mkFlake rec {
    inherit self inputs;
    inherit (nixpkgs) lib;
    supportedSystems = [ system ];

    channels = {
      nixos-unstable = {
        input = nixpkgs;
        patches = channel-patches;
      };
    };

    channelsConfig = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "cloudflare-warp"
      ];
    };

    hostDefaults = {
      inherit system;
      channelName = "nixos-unstable";
      specialArgs = { inherit system; };

      modules = [
        {
          nix = {
            generateNixPathFromInputs = true;
            generateRegistryFromInputs = true;
            linkInputs = true;
          };
        }

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }

        ./common.nix
      ];
    };

    hosts = {
      azure.modules = [
        inputs.archix.nixosModules.default
        ./programs/pacman.nix
        ./machines/azure.nix
      ];

      bandwagon.modules = [
        ./machines/bandwagon/configuration.nix
      ];
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    deploy.nodes = {
      azure = {
        hostname = "azure";
        profiles.system = {
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.azure;
          sshUser = "azureuser";
          user = "root";
        };
      };

      bandwagon = {
        hostname = "bandwagon";
        profiles.system = {
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.bandwagon;
          sshUser = "root";
        };
      };
    };

    nixosModules.synced = import ./services/synced;
  };
}