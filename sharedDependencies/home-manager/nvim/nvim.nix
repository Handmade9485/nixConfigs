{ config, pkgs, ... }:

{
  programs.neovim.vimAlias = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.extraConfig = ''
    set number
  '';
}
