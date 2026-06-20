{ self, inputs, ... }:
{
  flake.nixosModules.niri = { config, pkgs, lib, ... }:
  {
    programs.niri = {
      enable = true;
    };
    
    imports = [
      inputs.noctalia.nixosModules.default
    ];
    
    environment.systemPackages = with pkgs; [
      kitty
      emacs
      vscode
      firefox
      nautilus
      hyprpicker
      xwayland-satellite
      wl-clipboard
      grim
      slurp
      polkit
    ];
    
    #still doesnt work
    system.activationScripts.copyNiriConfig = {
      text = ''
        USER_HOME=$(eval echo ~$USER)
        mkdir -p "$USER_HOME/.config"
        rm -rf "$USER_HOME/.config/niri"
        cp -r ${./config} "$USER_HOME/.config/niri"
        chown -R $USER:$USER "$USER_HOME/.config/niri"
        echo "Niri config installed to $USER_HOME/.config/niri"
      '';
      deps = [];
    };
  };
}
