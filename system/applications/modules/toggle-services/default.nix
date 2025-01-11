{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "toggle-services" ''
      SERVICES=("$@")

      toggleService() {
          SERVICE="$1"

          if [[ ! "$SERVICE" == *".service"* ]]; then SERVICE="''${SERVICE}.service"; fi

          if systemctl list-unit-files "$SERVICE" &>/dev/null; then
              if systemctl is-active --quiet "$SERVICE"; then
                  echo "Stopping \"$SERVICE\"..."
                  sudo systemctl stop "$SERVICE"
              else
                  echo "Starting \"$SERVICE\"..."
                  sudo systemctl start "$SERVICE"
              fi
          else
              echo "\"$SERVICE\" does not exist"
          fi
      }

      # Retain sudo
      trap "exit" INT TERM; trap "kill 0" EXIT; sudo -v || exit $?; sleep 1; while true; do sleep 60; sudo -nv; done 2>/dev/null &

      for i in "''${SERVICES[@]}"
      do
          toggleService "$i"
      done
    '')
  ];
}
