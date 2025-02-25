{ config, pkgs, ... }:

let
  luantiServer = pkgs.callPackage ./luanti-server.nix {};
in {
  imports = [
  ];

  users.groups.luanti-server = {};

  users.users.luanti-server = {
    isSystemUser = true;
    home = "/var/lib/luanti-server";
    shell = pkgs.zsh;
    createHome = true;
    group = "luanti-server";
  };

  systemd.services.luanti-server = {
    enable = true;
    description = "Luanti Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    # Set up the executable path
    serviceConfig.ExecStart = "${pkgs.minetest}/bin/luantiserver --worldname Clonia2 --gameid mineclone2 --port 12345 --config /var/lib/luanti-server/.minetest/minetest.conf";
    serviceConfig.User = "luanti-server";
    serviceConfig.Group = "luanti-server";
    serviceConfig.Restart = "on-failure";
    
    # Set the auto-shutdown behavior (for auto-stop when idle)
    # serviceConfig.ExecStop = "nix run nixpkgs#luanti-server --shutdown";
    serviceConfig.TimeoutStopSec = "10m";  # Set a reasonable stop timeout
  };

  systemd.sockets.luanti-server = {
    listenStreams = [ "0.0.0.0:12345" ];
  };

  # Additional configurations
  environment.systemPackages = [
    pkgs.luanti-server  # Ensure luanti-server is installed
  ];

  networking.firewall.allowedUDPPorts = [
    8080
    12345
  ];

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    mapserver = {
      image = "ghcr.io/minetest-mapserver/mapserver:v4.9.2";
      ports = ["0.0.0.0:8080:8080"];
      volumes = [
        "/var/lib/luanti-server/.minetest/worlds/Clonia2:/minetest"
      ];
      workdir = "/minetest";
      cmd = [
      ];
    };
  };
}
