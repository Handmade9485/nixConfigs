{ inputs, ... }:
{
	flake.nixosModules.sopsTvMqtt = { config, pkgs, ... }:
	{
		imports = [
			inputs.sops-nix.nixosModules.sops
		];

		environment.systemPackages = with pkgs; [
			sops
			age
			ssh-to-age
			playerctl
			mosquitto
		];

		services.openssh.enable = true;
		sops.secrets.tvMqtt = {
			sopsFile = ./tvMqtt.env;
			format = "dotenv";
			owner = config.users.users.tv.name;
			group = config.users.users.tv.group;
		};
		sops.age = {
			sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			keyFile = "/var/lib/sops-nix/key.txt";
			generateKey = true;
		};

		systemd.user.services.tv-mqtt-player = {
			wantedBy = [ "graphical-session.target" ];
			partOf   = [ "graphical-session.target" ];

			path = with pkgs; [
				mosquitto
				playerctl
			];
			reloadIfChanged = true;

			serviceConfig = {
				EnvironmentFile = config.sops.secrets.tvMqtt.path;
				TimeoutStopSec = 5;
			};

			script = ''
			playerctl --follow metadata --player=%any --format '{"player":"{{playerName}}", "status":"{{status}}", "title":"{{xesam:title}}"}' | while read -r line; do
				echo $line
				echo $line | mosquitto_pub -h $host -p $port -u $user -P $password -t "tv/playback" --stdin-line
			done
			'';
		};

		systemd.services.tv-mqtt-system = {
			wantedBy = [ "multi-user.target" ];
			after    = [ "network-online.target" ];
			wants    = [ "network-online.target" ];

			path = with pkgs; [
				mosquitto
			];
			reloadIfChanged = true;

			serviceConfig = {
				EnvironmentFile = config.sops.secrets.tvMqtt.path;
				TimeoutStopSec = 5;
				Type = "oneshot";
				RemainAfterExit = true;

				ExecStart = ''${pkgs.mosquitto}/bin/mosquitto_pub -h $host -p $port -u $user -P $password -t "tv/system/state" -m "On"'';
				ExecStop = ''${pkgs.mosquitto}/bin/mosquitto_pub -h $host -p $port -u $user -P $password -t "tv/system/state" -m "Off"'';
			};
		};
	};
}
