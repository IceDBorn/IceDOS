{
  pkgs,
  ...
}:

let
  command = "reboot";
in
{
  icedos.internals.toolset.commands = [
    {
      bin = "${pkgs.writeShellScript command ''
        case "$1" in
          "")
            systemctl reboot -i
            ;;
          uefi)
            systemctl reboot --firmware-setup -i
            ;;
          *)
            echo "Unknown arg: $1" >&2
            exit 1
            ;;
        esac
      ''}";

      command = command;
      help = "reboot ignoring inhibitors and users, uefi supported by appending it as an argument";
    }
  ];
}
