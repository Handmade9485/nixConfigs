{ self, inputs, ... }:
{
	flake.nixosModules.niri = { config, pkgs, ... }:
	{
		programs.niri.enable = true;
	};
}
