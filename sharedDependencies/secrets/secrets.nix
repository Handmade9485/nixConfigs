let
  nanya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTrNBPKSEaoDC/po8s/v6RqPGETuozKLxbKuIlhOyrO";
  users = [ nanya ];

  desmosCalculator = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkFu5qNvXTdzD9C9UEesmEIEdePCT9wim6G/Mr/CoP7";
  systems = [ desmosCalculator ];
in
{
  "piSambaCredentials.age".publicKeys = [ nanya desmosCalculator ];
}
