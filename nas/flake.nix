{
  description = "nas flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager, agenix, disko, ...} @inputs :
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    specialArgs = inputs // { inherit system; };
    sharedModules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
        };
      }
      agenix.nixosModules.default
      {environment.systemPackages = [ agenix.packages.${system}.default ];}
    ];
  in {
    nixosConfigurations = rec {
      nas = lib.nixosSystem {
        inherit system specialArgs;
        modules = sharedModules ++ [
          disko.nixosModules.disko
          ./nas.nix
        ];
      };
    };
  };
}
