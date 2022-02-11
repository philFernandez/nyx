{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    bash
    coreutils-full
    moreutils
    ripgrep
    exa
    fd
    sd
    dua
    procs
  ];

  # Manage home-manager with home-manager (inception)
  programs.home-manager.enable = true;

  # Install home-manager manpages.
  manual.manpages.enable = true;

  # Install man output for any Nix packages.
  programs.man.enable = true;

  nyx.modules = {
    # theme.name = "duskfox";
    app = {
      alacritty = {
        enable = true;
        package = null;
      };
      kitty = {
        enable = true;
        fontSize = 14;
      };
      wezterm = {
        enable = true;
        package = null;
        fontSize = 14;
      };
    };
    dev = {
      python.enable = true;
    };
    shell = {
      bash.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      lf.enable = true;
      neovim.enable = true;
      nushell.enable = true;
      starship.enable = true;
      tmux.enable = true;
      xdg.enable = true;
      zoxide.enable = true;
      zsh.enable = true;

      gnupg = {
        enable = true;
        publicKey = ../../../../config/.gnupg/public.key;
        publicKeyName = "personal.key";
      };

      repo = {
        enable = true;
        cli = true;
        root = "${config.home.homeDirectory}/dev";
      };
    };
  };
}
