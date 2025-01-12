{ config, pkgs, ... }:

{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = 0.85;
    window.decorations = "buttonless";
    window.dynamic_padding = false;
    font.normal.family = "FiraCode Nerd Font";
    font.normal.style = "Regular";
  };
}
