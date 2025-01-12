{ config, pkgs, ... }:

{
  imports = [
    ../starship/starship.nix
    ../zoxide/zoxide.nix
  ];

  programs.zsh.enable = true;
  programs.zsh.autocd = false;
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.history.save = 50000;
  programs.zsh.history.path = "$HOME/.zsh_history";
  programs.zsh.history.share = true;
  programs.zsh.history.extended = false;
  programs.zsh.history.ignoreAllDups = true;
  programs.zsh.historySubstringSearch.enable = true;
  programs.zsh.initExtra = ''
    bindkey "^[[1;5D" backward-word
    bindkey "^[[1;5C" forward-word
    eval "$(zoxide init --cmd cd zsh)"
  '';

  programs.zsh.shellAliases.sysupgrade = "sudo nixos-rebuild switch --flake ~/.config/nixflakes && home-manager switch --flake ~/.config/nixflakes && nix flake update --flake ~/.config/nixflakes";
}
