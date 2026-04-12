{
	flake.nixosModules.sddm = { config, pkgs, ... }:
	{
		services.displayManager.sddm = {
			enable = true;
			extraPackages = [ pkgs.kdePackages.qtmultimedia ];
			theme = "${./sddm-astronaut-theme}";
		};
	};
}
