{ self, inputs, ... }:
{
  imports = [
    ./web.nix
    ./rust.nix
    ./go.nix
    ./python.nix
    ./java.nix
    ./devops.nix
    ./backend.nix
  ];

  perSystem = { pkgs, lib, config, ... }: let
    inherit (config) devShells;
    shells = builtins.removeAttrs devShells ["default" "all" "fullstack" "data" "cloud"];
  in {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        ripgrep
        fd
        jq
        yq
        just
        nix-output-monitor
        nix-tree
        delta
      ];
      shellHook = ''
        exec fish
      '';
    };

    devShells.all = pkgs.mkShell {
      inputsFrom = builtins.attrValues shells;
      shellHook = ''
        exec fish
      '';
    };

    devShells.fullstack = pkgs.mkShell {
      inputsFrom = with devShells; [ web rust go java backend ];
      shellHook = ''
        exec fish
      '';
    };

    devShells.data = pkgs.mkShell {
      inputsFrom = with devShells; [ python go ];
      shellHook = ''
        exec fish
      '';
    };

    devShells.cloud = pkgs.mkShell {
      inputsFrom = with devShells; [ devops go ];
      shellHook = ''
        exec fish
      '';
    };
  };
}
