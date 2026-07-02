{ self, inputs, ... }:
{
	flake.nixosModules.niri = { config, pkgs, ... }:
	{
		environment.systemPackages = with pkgs; [
			noctalia-shell
			libnotify
			xwayland-satellite
			kanshi
		];
		programs.xwayland.enable = true;
		programs.niri.enable = true;

		# These all need to be enabled globally for noctalia to manage them
		networking.networkmanager.enable = true;
		hardware.bluetooth.enable = true;
		services.upower.enable = true;
		services.power-profiles-daemon.enable = true;
	};

	flake.niriHome = { config, pkgs, ... }:
	let
		wallpaper = pkgs.fetchurl {
			url = "https://images.unsplash.com/photo-1696384036025-c7d7b7f6584d";
			hash = "sha256-8nazoPu+2FuTvuFluMT5luHP5lCGSZWwZvwzC3/5NSM=";
		};
	in {
		xdg.configFile."niri/config.kdl".source = ./config.kdl;

		xdg.configFile."noctalia/settings.json".source = ./noctalia/settings.json;
		xdg.configFile."noctalia/colors.json".source = ./noctalia/colors.json;
		home.file.".cache/noctalia/wallpapers.json" = {
			text = builtins.toJSON {
				defaultWallpaper = wallpaper;
			};
		};
		xdg.configFile."kanshi/config".text = ''
profile home_tv {
	output "LG Electronics LG TV 0x01010101" enable
	output "eDP-1" enable
}

profile home_laptop {
	output "eDP-1" enable
}
		'';
	};
}
