{
  description = "gateway flake";

  inputs = {
    # 最新 stable 分支的 nixpkgs
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # disko module
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zen-broswer
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      disko,
      zen-browser,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      # 用户名/家目录的唯一来源，全库模块通过 specialArgs 读取，避免散落硬编码
      username = "rum";
      homeDirectory = "/home/${username}";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          specialArgs = {
            inherit inputs username homeDirectory;
            # 如需 pin 某个包到 stable 分支，再启用下面这行：
            pkgs-stable = import ../../nixpkgs-stable { inherit system; config.allowUnfree = true; };
          };
          modules = [
            ./configuration.nix

            # Import disko module
            disko.nixosModules.disko
            ./disko/disko.nix

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.overwriteBackup = true;
              home-manager.users.${username} = {
                imports = [
                  ./home/home.nix
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit inputs username homeDirectory;
              };
            }
          ];
        };
      };
    };
}
