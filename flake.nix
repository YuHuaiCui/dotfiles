{
  description = "My NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    ags.url = "github:aylur/ags/v1"; # aylurs-gtk-shell-v1
  };

  outputs = inputs@{ self, nixpkgs, home-manager, zen-browser, ... }:
    let
      host = "nixos";
      username = "cyh";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      zen = zen-browser.packages."${system}";
    in {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
        specialArgs = { 
          inherit system;
          inherit inputs;
          inherit username;
          inherit host;
        };
        modules = [ ./hosts/${host}/configuration.nix ];
      };
    };
    homeConfigurations = {
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ /hosts/${host}/home.nix ];
        extraSpecialArgs = { zen-browser = zen; };
      };
    };
  };
  
}
