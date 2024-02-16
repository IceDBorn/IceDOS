{ pkgs, name, buildPath, installPath, message, type }:
pkgs.writeShellScriptBin "update-${name}" ''
  currentVersion=$(cat "${buildPath}/version" | grep -oE 'GE-${type}+[0-9]+-[0-9]+')
  installedVersions=$(ls "${installPath}" | grep "GE" 2> /dev/null)

  function install () {
    echo "updating ${message}..."
    mkdir -p "${installPath}"
    cp -r ${buildPath} "${installPath}/$currentVersion"
  }

  if [ ! -z "$installedVersions" ]
  then
      while IFS= read -r version ; do
          if [ "$version" == "$currentVersion" ]
          then
              exit 0
          fi
      done <<< "$installedVersions"
  fi

  install
''
