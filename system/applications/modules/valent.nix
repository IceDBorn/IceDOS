{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);

  deviceId = cfg.applications.valent.deviceId;
in
mkIf (cfg.applications.valent.enable)
{
  environment.systemPackages = [ pkgs.valent ];

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
          dconf.settings = {
            "ca/andyholmes/valent/device/${deviceId}/plugin/battery" = {
              full-notification = true;
              full-notification-level = 80.0;
            };

            "ca/andyholmes/valent/device/${deviceId}/plugin/connectivity_report" = {
              offline-notification = true;
            };

            "ca/andyholmes/valent/device/${deviceId}/plugin/telephony" = {
              ringing-volume = -1;
              ringing-pause = true;
            };

            "ca/andyholmes/valent/device/${deviceId}/plugin/clipboard" = {
              auto-pull = true;
              auto-push = true;
            };

            "ca/andyholmes/valent/device/${deviceId}/plugin/contacts" = {
              enabled = false;
            };

            "ca/andyholmes/valent/device/${deviceId}/plugin/notification" = {
              enabled = false;
            };

            "ca/andyholmes/valent/device/${deviceId}/plugin/sms" = {
              enabled = false;
            };
          };
        };
      }
    ) users;
}
