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

    # zen-browser
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

      # 抽出来复用：NixOS 配置与 Home Manager 配置共用
      nixosConfiguration = nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs username homeDirectory;
          # pin 某个包到 stable 分支时使用
          pkgs-stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
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
                inputs.zen-browser.homeModules.twilight
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit username homeDirectory;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations.nixos = nixosConfiguration;

      # standalone Home Manager 配置，供 nixd 的 home-manager 选项补全使用
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./home/home.nix
          inputs.zen-browser.homeModules.twilight
        ];
        extraSpecialArgs = {
          inherit username homeDirectory;
          # 当前 Home 侧没有模块引用 nixosConfig，暂不传递以避免完整求值 NixOS 系统
        };
      };
    };
}
