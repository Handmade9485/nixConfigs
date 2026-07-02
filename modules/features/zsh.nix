{ self, inputs, ... }:
{
	flake.zsh = { config, pkgs, ... }:
	{
		imports = [
			self.zoxide
			self.starship
		];
		programs.zoxide.enableZshIntegration = true;
		programs.starship.enableZshIntegration = true;

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
 		programs.zsh.initContent = ''
 			bindkey "^[[1;5D" backward-word
 			bindkey "^[[1;5C" forward-word
			systest() {
				sudo nixos-rebuild test --flake /etc/nixos#$1
			}
			sysupgrade() {
				sudo nixos-rebuild switch --flake /etc/nixos#$1
			}
 		'';

		programs.zsh.shellAliases = {
			nix-shell = "nix-shell --command zsh";
			music-dlp = "yt-dlp --embed-metadata -f 'ba' -x --audio-format 'mp3' --cookies-from-browser firefox";
		};
	};
}
