{ inputs, ... }:
{
	flake.nixosModules.sopsPiLogin = { config, pkgs, ... }:
	{
		imports = [
			inputs.sops-nix.nixosModules.sops
		];

		environment.systemPackages = with pkgs; [
			sops
			age
			ssh-to-age
		];

		services.openssh.enable = true;
		sops.defaultSopsFile = "${inputs.self}/sops.yaml";
		sops.secrets.piLogin = {
				sopsFile = ./piLogin.env;
				format = "dotenv";
				owner = config.users.users.nanya.name;
				group = config.users.users.nanya.group;
		};
	};
}
