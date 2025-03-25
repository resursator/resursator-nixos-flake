{
  description = "My kde flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    gimpnixpkgs.url = "github:jtojnar/nixpkgs?ref=gimp-meson";
    rustdesknixpkgs.url = "github:nixos/nixpkgs?rev=8a4fbb9582466e8abbe9f4cc4fd455bbcc0861ba";
    zedoldnixpkgs.url = "github:nixos/nixpkgs?rev=2463284c0898838f2a726a45489e3e23e45984fd";
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
  };

  outputs = { nixpkgs, home-manager, plasma-manager, ... } @ inputs:
  let
    gimppkgs = inputs.gimpnixpkgs.legacyPackages.x86_64-linux;
    zenpkgs = inputs.zen-browser.packages.x86_64-linux;
    zedpkgs = inputs.zedoldnixpkgs.legacyPackages.x86_64-linux;
    rustdeskpkgs = inputs.rustdesknixpkgs.legacyPackages.x86_64-linux;
  in
  {
    nixosConfigurations.homenix = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; inherit gimppkgs; inherit zenpkgs; inherit zedpkgs; inherit rustdeskpkgs; };
      modules = [
        ./hosts/homenix/configuration.nix
        ./modules/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
        }
      ];
    };
  };
}
