{ self, inputs, ... }:
{
	flake.nixosModules.officePcHardware = { config, lib, pkgs, modulesPath, ... }:
    {
		imports = [ ];

		boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
		boot.initrd.kernelModules = [ ];
		boot.kernelModules = [ ];
		boot.extraModulePackages = [ ];

		fileSystems."/" =
			{ device = "/dev/disk/by-uuid/f002e12f-e094-4dda-b33d-950665fc2bfe";
			fsType = "ext4";
			};

		swapDevices = [ ];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
		virtualisation.virtualbox.guest.enable = true;
	};
}
