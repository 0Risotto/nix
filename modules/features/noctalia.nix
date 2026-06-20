{ self, inputs, ... }:
{
  flake.nixosModules.noctalia = { config, pkgs, lib, ... }: {

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    nix.settings = {
      substituters = [ "https://noctalia.cachix.org" ];
      trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
