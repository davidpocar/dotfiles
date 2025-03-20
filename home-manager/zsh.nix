{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
        update = "sudo nix flake update ~/dotfiles";
        upgrade = "sudo nixos-rebuild switch --upgrade-all --flake ~/dotfiles";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "forgit";
          src = pkgs.zsh-forgit;
        }
        {
          name = "fzf-history-search";
          src = pkgs.zsh-fzf-history-search;
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
        }
      ];
      oh-my-zsh = {
        enable = true;
      };
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      enableCompletion = true;
      initExtra = ''
        setopt NO_NOMATCH
        source ~/.p10k.zsh
      '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
