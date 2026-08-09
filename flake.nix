{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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

    preservation.url = "github:nix-community/preservation";
  };

  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs: 
  let
    system = "x86_64-linux";
    channel-patches = [
      # Add nixpkgs patches here
    ];
    preservation-modules = [
      inputs.preservation.nixosModules.preservation
      ./preservation.nix
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
        ./machines/bandwagon/major/configuration.nix
      ];

      bandwagon-mini.modules = [
        ./machines/bandwagon/mini/configuration.nix
      ];

      bandwagon-cn2gia.modules = [
        ./machines/bandwagon/cn2gia/configuration.nix
      ] ++ preservation-modules;
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

      bandwagon-mini = {
        hostname = "bandwagon-mini";
        profiles.system = {
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.bandwagon-mini;
          sshUser = "root";
        };
      };

      bandwagon-cn2gia = {
        hostname = "bandwagon-cn2gia";
        profiles.system = {
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.bandwagon-cn2gia;
          sshUser = "root";
        };
      };
    };

    nixosModules.synced = import ./services/synced;
  };
}