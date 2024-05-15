{
  description = "System flake";

  inputs = {
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle.url = "github:hyprwm/hypridle";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    leap-spooky = {
      flake = false;
      url = "github:ggandor/leap-spooky.nvim";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim.url = "github:nix-community/nixvim";

    tree-sitter-nu = {
      url = "github:nushell/tree-sitter-nu";
      flake = false;
    };
  };

  outputs = {
    emacs-overlay,
    hm,
    hyprland,
    hyprlock,
    hyprpaper,
    neovim-nightly-overlay,
    nixos-hardware,
    nixpkgs,
    nixvim,
    ...
  } @ inputs : let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config.allowUnfree = true;

      overlays = [ 
        emacs-overlay.overlay
        neovim-nightly-overlay.overlay 
      ];
    };
  in {
    nixosConfigurations = {
      timbuktu = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;

        specialArgs = { inherit inputs; };

        modules = [
          ./nix/hardware-configuration.nix
          nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7
          ./nix/configuration.nix

          hm.nixosModules.home-manager {
            home-manager.extraSpecialArgs = {
              inherit inputs;

              colors = import ./nix/colors.nix;
            };

            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.david = import ./nix/home.nix;
          }
        ];
      };
    };
  };
}
