{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkForce
    mkIf
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
mkIf (config.icedos.desktop.plasma) {
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;
      in
      {
        ${username} = {
          imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

          catppuccin = {
            enable = true;
            accent = "mauve";
            flavor = "mocha";
          };

          gtk = {
            enable = true;
            theme.name = mkForce "Breeze";
            cursorTheme.name = mkForce "Breeze";
            iconTheme.name = mkForce "Breeze";
          };

          qt = {
            enable = true;
            style.name = "kvantum";
            platformTheme.name = "kvantum";
          };
        };
      }
    ) users;
}
