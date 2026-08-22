{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, ... }@inputs: {
    nixosConfigurations.iodis-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };

            users.iodis = import ./home.nix;
            backupFileExtension = "backup";
          };}

        # CachyOS Kernel
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
          # Use the exact nixpkgs revision as defined in this repo to ensure binary cache hits.
            inputs.nix-cachyos-kernel.overlays.pinned
          ];
          nix.settings = {
            substituters = [ "https://attic.xuyh0120.win/lantian" ];
            trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
          };
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
        })
      ];
    };
  };
}