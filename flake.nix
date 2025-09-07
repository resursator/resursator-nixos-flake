{
  description = "My kde flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      plasma-manager,
      sops-nix,
      ...
    }@inputs:
    let
      zenpkgs = inputs.zen-browser.packages.x86_64-linux;
      hosts = {
        homenix = "homenix";
        homenas = "homenas";
      };
      USERNAME = "resursator";
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (hn: {
          name = hn;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs zenpkgs USERNAME;
              HOSTNAME = hn;
            };
            modules = [
              ./hosts/${hn}/configuration.nix
              ./modules/default.nix
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              }
            ];
          };
        }) (builtins.attrValues hosts)
      );
    };
}
