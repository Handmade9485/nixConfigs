{ config, pkgs, lib, ... }:

{
  age.secrets.piSambaCredentials.file = ../../secrets/piSambaCredentials.age;

  fileSystems."/mnt/myMedia" = {
    device = "//10.0.3.14/MyMedia";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "_netdev"
      "nofail"
      "credentials=${config.age.secrets.piSambaCredentials.path}"
      "uid=1000"
      "gid=100"
    ];
  };

  security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
    };
}
