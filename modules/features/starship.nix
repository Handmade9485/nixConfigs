{
	flake.starship = { config, pkgs, ... }:
	{
		programs.starship = {
			enable = true;
			presets = [ "catppuccin-powerline" ];
		};
	};
}
