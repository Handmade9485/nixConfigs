{ pkgs, ... }:

{
  users.users.nanya = {
    isNormalUser = true;
    description = "nanya";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "m3inp4ss";
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTrNBPKSEaoDC/po8s/v6RqPGETuozKLxbKuIlhOyrO nanya@DesmosCalculator"
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    discord
    jetbrains.idea-community-bin
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
    zsh
  ];

  home-manager.users.nanya = {
    imports = [
      ../home-manager/alacritty/alacritty.nix
      ../home-manager/zsh/zsh.nix
      ../home-manager/nvim/nvim.nix
    ];

    programs.git.enable = true;
    programs.git.userEmail = "mail@example.com";
    programs.git.userName = "name";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.05"; # Please read the comment before changing.
  };
}
