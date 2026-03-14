{
  description = "MSI Vector GP77 13VG — NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, home-manager, mango, stylix, firefox-addons, ... }: {
    nixosConfigurations.vector = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        disko.nixosModules.disko
        mango.nixosModules.mango
        stylix.nixosModules.stylix
        ./modules/appearance.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pomid0rko_0 = import ./home/pomid0rko_0.nix;
          home-manager.extraSpecialArgs = {
            inherit mango;
            firefox-addons = firefox-addons.packages.x86_64-linux;
          };
        }
      ];
    };
  };
}
