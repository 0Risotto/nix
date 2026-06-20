{ self, inputs, ... }:
{
  flake.nixosModules.systemApps = { config, pkgs, ... }:
  {
    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      #editors
      vscode
      zed-editor
      bibata-cursors      
 vesktop     
      #terminal stuff
      git
      gh
      fish
      starship
      eza
      bat
      # I hated adding this
      fastfetch
      
      #themes and icons
      flat-remix-gtk
      flat-remix-icon-theme
      adwaita-icon-theme
      nwg-look
      
      #editors
      neovim     
    ];
  };
}
