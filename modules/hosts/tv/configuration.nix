{ self, inputs, ... }:
{
	flake.nixosModules.tvConfiguration = { config, pkgs, ... }:
	{
		imports =
		[
			inputs.home-manager.nixosModules.home-manager
			self.nixosModules.tvHardware
			self.nixosModules.sddm
			self.nixosModules.niri
			self.nixosModules.sopsTvMqtt
			self.nixosModules.sopsTvMounts
		];

		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		networking.hostName = "tv";
		# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

		# Configure network proxy if necessary
		# networking.proxy.default = "http://user:password@proxy:port/";
		# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

		# Enable networking
		networking.networkmanager.enable = true;

		# Set your time zone.
		time.timeZone = "Europe/Berlin";

		# Select internationalisation properties.
		i18n.defaultLocale = "en_US.UTF-8";

		i18n.extraLocaleSettings = {
			LC_ADDRESS = "de_DE.UTF-8";
			LC_IDENTIFICATION = "de_DE.UTF-8";
			LC_MEASUREMENT = "de_DE.UTF-8";
			LC_MONETARY = "de_DE.UTF-8";
			LC_NAME = "de_DE.UTF-8";
			LC_NUMERIC = "de_DE.UTF-8";
			LC_PAPER = "de_DE.UTF-8";
			LC_TELEPHONE = "de_DE.UTF-8";
			LC_TIME = "de_DE.UTF-8";
		};

		# Enable the X11 windowing system.
		services.xserver.enable = true;

		services.xserver.windowManager.awesome.enable = true;

		# Enable the KDE Plasma Desktop Environment.
		services.desktopManager.plasma6.enable = true;

		# Configure keymap in X11
		services.xserver.xkb = {
			layout = "de";
			variant = "";
		};

		# Configure console keymap
		console.keyMap = "de";

		# Enable CUPS to print documents.
		services.printing.enable = true;
		# Enable sound with pipewire.
		services.pulseaudio.enable = false;
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		# Enable touchpad support (enabled default in most desktopManager).
		services.libinput.enable = true;

		# Define a user account. Don't forget to set a password with ‘passwd’.
		users.users.tv = {
			isNormalUser = true;
			description = "tv";
			extraGroups = [ "networkmanager" "wheel" "cdrom" ];
			packages = with pkgs; [
				kdePackages.kate
				mpv
				steam
				lnav
				kodi
			];
			shell = pkgs.zsh;
		};
		programs.zsh.enable = true;

		home-manager.users.tv = {
			imports = [
				self.zsh
				self.alacritty
				self.nvim
				self.niriHome
			];

			programs.git.enable = true;
			programs.git.settings.user.email = "mail@example.com";
			programs.git.settings.user.name = "name";

			programs.chromium.enable = true;
			xdg.desktopEntries.youtube = let
				icon = pkgs.fetchurl {
					url = "https://www.google.com/s2/favicons?sz=256&domain=youtube.com";
					hash = "sha256-y2rbGYQ7ZFvCJxgfUnRvAemo/abBEzjKwjxZd8fSOGw=";
				};
			in {
				name = "Youtube";
				exec = "chromium --app=https://www.youtube.com";
				icon = icon;
				type = "Application";
				categories = [ "Network" ];
				settings = {
					StartupWMClass = "youtube";
				};
			};
			xdg.desktopEntries.stash = let
				icon = pkgs.fetchurl {
					url = "https://raw.githubusercontent.com/stashapp/Stash-Docs/refs/heads/main/favicon.ico";
					hash = "sha256-5g/1W75LJAYaCElbJVuGaGhRiQ3HEk5iqB3Sy09dIIQ=";
				};
			in {
				name = "Stash";
				exec = ''chromium --app="http://10.0.3.14:9999"'';
				icon = icon;
				type = "Application";
				categories = [ "Network" ];
				settings = {
					StartupWMClass = "stashapp";
				};
			};

			# This value determines the Home Manager release that your configuration is
			# compatible with. This helps avoid breakage when a new Home Manager release
			# introduces backwards incompatible changes.
			#
			# You should not change this value, even if you update Home Manager. If you do
			# want to update the value, then make sure to first check the Home Manager
			# release notes.
			home.stateVersion = "25.11"; # Please read the comment before changing.
		};

		# Install firefox.
		programs.firefox.enable = true;

		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

		# List packages installed in system profile. To search, run:
		# $ nix search wget
		environment.systemPackages = with pkgs; [
			btop
			jellyfin-desktop
			pulseaudio
		];

		# This value determines the NixOS release from which the default
		# settings for stateful data, like file locations and database versions
		# on your system were taken. It‘s perfectly fine and recommended to leave
		# this value at the release version of the first install of this system.
		# Before changing this value read the documentation for this option
		# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
		system.stateVersion = "25.11"; # Did you read the comment?
	};
}
