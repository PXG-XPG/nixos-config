{
  description = "gateway flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 最新 stable 分支的 nixpkgs，用于回退个别软件包的版本
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpak
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixvim,
      home-manager,
      nixpak,
      ...
  }: 
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./configuration.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.rum = {
              imports = [
                ./home/home.nix
                nixvim.homeModules.nixvim
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
      };
    };
  };
}
