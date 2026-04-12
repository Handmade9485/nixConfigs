{ self, inputs, ... }:
{
	flake.nixosModules.nanya = { pkgs, lib, ... }:
	{
		imports = [
			inputs.home-manager.nixosModules.home-manager
		];

		users.users.nanya = {
			isNormalUser = true;
			description = "nanya";
			extraGroups = [ "networkmanager" "wheel" "cdrom" "docker" "vboxusers" ];
			initialPassword = "m3inp4ss";
			packages = with pkgs; [
			];
			openssh.authorizedKeys.keys = [
				"nanya AAAAC3NzaC1lZDI1NTE5AAAAIBTrNBPKSEaoDC/po8s/v6RqPGETuozKLxbKuIlhOyrO nanya@DesmosCalculator"
			];
			shell = pkgs.zsh;
		};
		programs.zsh.enable = true;
		sops.age.keyFile = "/home/nanya/.config/sops/age/keys.txt";

		environment.systemPackages = with pkgs; [
			discord
			obsidian
			thunderbird
			tor-browser
			bitwarden-desktop
			kdePackages.filelight
			kdePackages.kate
			kdePackages.kdeconnect-kde
			kdePackages.kdevelop
			kdePackages.kimageformats
			signal-desktop
			telegram-desktop
		];

		home-manager.users.nanya = {
			imports = [
				self.zsh
				self.alacritty
				self.nvim
			];

			programs.git.enable = true;
			programs.git.settings.user.email = "mail@example.com";
			programs.git.settings.user.name = "name";

			# This value determines the Home Manager release that your configuration is
			# compatible with. This helps avoid breakage when a new Home Manager release
			# introduces backwards incompatible changes.
			#
			# You should not change this value, even if you update Home Manager. If you do
			# want to update the value, then make sure to first check the Home Manager
			# release notes.
			home.stateVersion = "25.11"; # Please read the comment before changing.
		};
	};
}
