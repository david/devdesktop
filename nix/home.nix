{ config, inputs, pkgs, ... }: {
  imports = [
    ./gnome.nix
    # ./hyprdesktop.nix
  ];

  home.file."${config.xdg.dataHome}/fonts".source = ../fonts;

  home.packages = with pkgs; [
    bat
    blesh
    btop
    delta
    discord
    fd
    fzf
    gh
    git
    grc
    lazygit
    lsd
    neovide
    ripgrep
    slack
    starship
    stow
    vivaldi
    vivaldi-ffmpeg-codecs
    wezterm
    wl-clipboard
    zoxide
  ] ++ [ inputs.neovim-nightly-overlay.packages.${pkgs.system}.default ];

  home.stateVersion = "23.11";

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
  };
}
