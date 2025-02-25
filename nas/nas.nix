{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix") # auto generated
      /etc/nixos/sharedDependencies/configuration.nix
      /etc/nixos/sharedDependencies/users/nanya.nix
      ./services/luantiServer.nix
    ];

  networking.hostName = "nas"; # Define your hostname.
  networking.hostId = "4e98920d";
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      22
    ];
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.loader.efi.canTouchEfiVariables = true;

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    podman-compose
    zsh
  ];

  virtualisation.podman.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTrNBPKSEaoDC/po8s/v6RqPGETuozKLxbKuIlhOyrO" # nanya
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  services.zfs.autoScrub.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f54180eb-4418-4f1e-bbc4-831fcb881bb2";
      fsType = "ext4";
    };

  swapDevices = [ ];

#   disko.devices = {
#     disk = {
#       boot.type = "disk";
#       boot.device = "/dev/sda";
#       boot.content.type = "gpt";
#       boot.content.partitions = {
#         ESP = {
#           size = "64M";
#           type = "EF00";
#           content = {
#             type = "filesystem";
#             format = "vfat";
#             mountpoint = "/boot";
#             mountOptions = [ "umask=0077" ];
#           };
#         };
#         encryptedSwap = {
#           size = "16G";
#           content = {
#             type = "swap";
#             randomEncryption = true;
#             discardPolicy = "both";
#             priority = 100; # prefer to encrypt as long as we have space for it
#           };
#         };
#         zfs = {
#           size = "100%";
#           content = {
#             type = "zfs";
#             pool = "zroot";
#           };
#         };
#       };
#     };
#     zpool = {
#       zroot = {
#         type = "zpool";
#         mode = "";
#         # Workaround: cannot import 'zroot': I/O error in disko tests
#         options.cachefile = "none";
#         rootFsOptions = {
#           compression = "zstd";
#           "com.sun:auto-snapshot" = "false";
#         };
#         mountpoint = "/";
#         postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
#
#         datasets = {
#           zfs_fs = {
#             type = "zfs_fs";
#             mountpoint = "/zfs_fs";
#             options."com.sun:auto-snapshot" = "true";
#           };
#           zfs_unmounted_fs = {
#             type = "zfs_fs";
#             options.mountpoint = "none";
#           };
#           zfs_legacy_fs = {
#             type = "zfs_fs";
#             options.mountpoint = "legacy";
#             mountpoint = "/zfs_legacy_fs";
#           };
#           encrypted = {
#             type = "zfs_fs";
#             options = {
#               mountpoint = "none";
#               encryption = "aes-256-gcm";
#               keyformat = "passphrase";
#               keylocation = "prompt";
#             };
#           };
#           "encrypted/test" = {
#             type = "zfs_fs";
#             mountpoint = "/zfs_crypted";
#           };
#         };
#       };
#     };
#   };
}
