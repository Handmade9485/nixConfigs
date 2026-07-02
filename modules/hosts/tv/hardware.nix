{ self, inputs, ... }:
{
	flake.nixosModules.tvHardware = { config, lib, pkgs, modulesPath, ... }:
	{
		imports =
		[
			(modulesPath + "/installer/scan/not-detected.nix")
		];

		boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
		boot.initrd.kernelModules = [ "sg" "sr_mod" ];
		boot.kernelModules = [ ];
		boot.extraModulePackages = [ ];

		fileSystems."/" =
		{
			device = "/dev/mapper/luks-f5015b58-5b16-4e48-a924-5446095c8b05";
			fsType = "ext4";
		};

		boot.initrd.luks.devices."luks-f5015b58-5b16-4e48-a924-5446095c8b05".device = "/dev/disk/by-uuid/f5015b58-5b16-4e48-a924-5446095c8b05";

		fileSystems."/boot" =
		{
			device = "/dev/disk/by-uuid/DAC4-43E1";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};

		swapDevices = [ ];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
		hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	};
}
