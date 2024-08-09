{
  description = "My kde flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgsstable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    stylix.url = "github:danth/stylix";
    background-img = {
      url = "./resources/tyler-van-der-hoeven-_ok8uVzL2gI-unsplash.jpg";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, plasma-manager, stylix, ... } @ inputs:
  {
    nixosConfigurations.homenix = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/homenix/configuration.nix
        ./modules/default.nix
        # stylix.nixosModules.stylix ./modules/nixos/style.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
          # home-manager.users."resursator" = import ./modules/nixos/home.nix;
        }
      ];
    };
  };
}
