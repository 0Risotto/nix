{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      # kitty doesn't clear properly
      alias clear "printf '\033[2J\033[3J\033[1;1H'"
      alias celar "printf '\033[2J\033[3J\033[1;1H'"
      alias claer "printf '\033[2J\033[3J\033[1;1H'"
      alias pamcan pacman
      alias q 'qs -c ii'

      if test "$TERM" != "linux"
        alias ls 'eza --icons'
      end
      if test "$TERM" = "xterm-kitty"
        alias ssh 'kitten ssh'
      end

      set -g FLAKE "$HOME/git/dotties/nixos"

      function dev --inherit-variable FLAKE
        if test (count $argv) -eq 0
          nix develop "$FLAKE#default"
        else if string match -qr -- '^(--help|-h|list)$' "$argv[1]"
          echo "Available devshells:"
          nix eval "$FLAKE#devShells.x86_64-linux" --apply 'builtins.attrNames' 2>/dev/null \
            | string match -ra '\w+' \
            | while read -l shell
              echo "    $shell"
            end
          echo ""
          echo "Usage:"
          echo "  dev <name>           Enter a single devshell"
          echo "  dev <name> <name>    Combine multiple devshells"
          echo "  dev all              Everything"
          echo "  dev fullstack        web + rust + go + java + backend"
          echo "  dev data             python + go"
          echo "  dev cloud            devops + go"
        else if test (count $argv) -eq 1
          nix develop "$FLAKE#"$argv[1]
        else
          # Combine multiple devshells dynamically
          set -l shellList (string join ' ' $argv)
          set -l tmpfile (mktemp /tmp/devshell.XXXXXX.nix)
          echo "let" > $tmpfile
          echo "  flake = builtins.getFlake \"$FLAKE\";" >> $tmpfile
          echo "  pkgs = import flake.inputs.nixpkgs { system = \"x86_64-linux\"; };" >> $tmpfile
          echo "  shells = with flake.devShells.x86_64-linux; [ $shellList ];" >> $tmpfile
          echo "in pkgs.mkShell {" >> $tmpfile
          echo "  inputsFrom = shells;" >> $tmpfile
          echo "  shellHook = \"exec fish\";" >> $tmpfile
          echo "}" >> $tmpfile
          nix develop -f $tmpfile
          rm $tmpfile
        end
      end
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;

      format = ''
        $cmd_duration 󰜥 $directory $git_branch
        $character'';

      character = {
        success_symbol = "[   ](bold fg:blue)";
        error_symbol = "[   ](bold fg:red)";
      };

      package.disabled = true;

      git_branch = {
        style = "bg: cyan";
        symbol = "󰘬";
        truncation_length = 12;
        truncation_symbol = "";
        format = "󰜥 [](bold fg:cyan)[$symbol $branch(:$remote_branch)](fg:black bg:cyan)[ ](bold fg:cyan)";
      };

      git_commit = {
        commit_hash_length = 4;
        tag_symbol = " ";
      };

      git_state = {
        format = "[\($state( $progress_current of $progress_total)\)](\$style) ";
        cherry_pick = "[🍒 PICKING](bold red)";
      };

      git_status = {
        conflicted = " 🏳 ";
        ahead = " 🏎💨 ";
        behind = " 😰 ";
        diverged = " 😵 ";
        untracked = " 🤷 ‍";
        stashed = " 📦 ";
        modified = " 📝 ";
        staged = "[++\($count\)](green)";
        renamed = " ✍️ ";
        deleted = " 🗑 ";
      };

      hostname = {
        ssh_only = false;
        format = "[•$hostname](bg:cyan bold fg:black)[](bold fg:cyan)";
        trim_at = ".companyname.com";
        disabled = false;
      };

      line_break.disabled = false;

      memory_usage = {
        disabled = true;
        threshold = -1;
        symbol = " ";
        style = "bold dimmed green";
      };

      time = {
        disabled = true;
        format = "🕙[\[ $time \]](\$style) ";
        time_format = "%T";
      };

      username = {
        style_user = "bold bg:cyan fg:black";
        style_root = "red bold";
        format = "[](bold fg:cyan)[$user](\$style)";
        disabled = false;
        show_always = true;
      };

      directory = {
        home_symbol = "  ";
        read_only = "  ";
        style = "bg:green fg:black";
        truncation_length = 6;
        truncation_symbol = " ••/";
        format = "[](bold fg:green)[󰉋 →$path](\$style)[](bold fg:green)";
        substitutions = {
          "Desktop" = "  ";
          "Documents" = "  ";
          "Downloads" = "  ";
          "Music" = " 󰎈 ";
          "Pictures" = "  ";
          "Videos" = "  ";
          "GitHub" = " 󰊤 ";
        };
      };

      cmd_duration = {
        min_time = 0;
        format = "[](bold fg:yellow)[󰪢 $duration](bold bg:yellow fg:black)[](bold fg:yellow)";
      };
    };
  };
}
