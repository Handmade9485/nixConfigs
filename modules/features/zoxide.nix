{
	flake.zoxide = { config, pkgs, ... }:
	{
		programs.zoxide = {
			enable = true;
			options = [ "--cmd cd" ];
		};

		home.packages = [
			pkgs.fzf
		];
	};
}
