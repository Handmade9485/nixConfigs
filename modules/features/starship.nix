{
	flake.starship = { config, pkgs, ... }:
	{
		programs.starship = {
			enable = true;
			presets = [ "catppuccin-powerline" ];
			settings.cmd_duration.show_notifications = false;
		};
	};
}
