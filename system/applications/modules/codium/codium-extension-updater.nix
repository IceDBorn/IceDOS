{ config, pkgs }:

let
  cfg = config.icedos.applications.codium;
in
pkgs.writeShellScriptBin "update-codium-extensions" ''
  EXTENSIONS=(${builtins.toString cfg.extensions})
  GOAL="''${#EXTENSIONS[@]}"
  JOBS_LOG=$(mktemp --tmpdir jobs.XXXXX)
  THREADS=$(nproc)

  echo 0 > "$JOBS_LOG"

  i=0
  while (( i < GOAL )); do
  	JOBS=$(<"$JOBS_LOG")

  	if (( JOBS > THREADS )); then sleep 0.5 && continue; fi

  	echo -ne "Updating codium extensions ($(( i + 1 ))/$GOAL)... \r"

  	(
  		echo $((JOBS + 1)) > "$JOBS_LOG" &&
  		JOBS=$(<"$JOBS_LOG") &&
  		codium --force --install-extension "''${EXTENSIONS[$i]}" > /dev/null &&
  		echo $((JOBS - 1)) > "$JOBS_LOG"
  	) & i=$(( i + 1 )) && sleep 0.1
  done
''
