_:

{
  flake.nixosModules.appearanceDefaults =
    { config, pkgs, ... }:

    {
      i18n.defaultLocale = config.settings.locale;

      i18n.extraLocaleSettings = builtins.listToAttrs (
        map
          (k: {
            name = k;
            value = config.settings.locale;
          })
          [
            "LC_ADDRESS"
            "LC_IDENTIFICATION"
            "LC_MEASUREMENT"
            "LC_MONETARY"
            "LC_NAME"
            "LC_NUMERIC"
            "LC_PAPER"
            "LC_TELEPHONE"
            "LC_TIME"
          ]
      );

      time.timeZone = config.settings.timezone;

      fonts = {
        packages = with pkgs; [
          inter
          roboto
          roboto-mono
          noto-fonts
          noto-fonts-color-emoji
          liberation_ttf
          nerd-fonts.jetbrains-mono
        ];

        fontconfig.defaultFonts = {
          sansSerif = [ "Inter" ];
          monospace = [ "Roboto Mono" ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };

      environment.systemPackages = with pkgs; [
        flat-remix-gtk
        flat-remix-icon-theme
        bibata-cursors
        nwg-look
      ];

    };
}
