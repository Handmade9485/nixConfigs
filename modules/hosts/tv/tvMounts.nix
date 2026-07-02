{ inputs, ... }:
{
	flake.nixosModules.sopsTvMounts = { config, pkgs, ... }:
	{
		imports = [
			inputs.sops-nix.nixosModules.sops
		];

		environment.systemPackages = with pkgs; [
			sops
			age
			ssh-to-age
			cifs-utils
		];

		services.openssh.enable = true;
		sops.secrets.piSambaCredentials = {
			sopsFile = ./piSambaCredentials.env;
			format = "dotenv";
			owner = config.users.users.tv.name;
			group = config.users.users.tv.group;
		};
		sops.age = {
			sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			keyFile = "/var/lib/sops-nix/key.txt";
			generateKey = true;
		};
		fileSystems."/mnt/music" = {
			device = "//10.0.3.14/MyMedia/Music";
			fsType = "cifs";
			options = let
			# this line prevents hanging on network split
			automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
			in ["${automount_opts},credentials=${config.sops.secrets.piSambaCredentials.path},uid=${config.users.users.tv.name},gid=${config.users.users.tv.group}"];
		};
	};
}
