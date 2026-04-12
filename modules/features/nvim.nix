{
	flake.nvim = { config, pkgs, ... }:
	{
		programs.neovim = {
			enable = true;
			vimAlias = true;
			defaultEditor = true;
		};
		programs.neovim.extraConfig = ''
			set number
			set relativenumber
			set tabstop=2
			set noexpandtab
		'';
	};
}
