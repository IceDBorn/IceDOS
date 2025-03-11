{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "clear-xdg-portal-files" ''
      PORTAL="xdg-desktop-portal"

      rm -rf "$HOME/.config/$PORTAL"
      rm -rf "$HOME/.cache/$PORTAL"
      sudo rm -rf "/etc/xdg/$PORTAL"
      sudo rm -rf "/usr/share/$PORTAL"
    '')
  ];
}
