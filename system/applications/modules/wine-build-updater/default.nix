{
  pkgs,
  name,
  buildPath,
  installPath,
  message,
  type,
}:
pkgs.writeShellScriptBin "update-${name}" ''
  mkdir -p -m 755 "${installPath}"

  currentVersion=$(cat "${buildPath}/version" | grep -oE 'GE-${type}+[0-9]+-[0-9]+')
  installedVersions=$(ls "${installPath}" | grep "GE" 2> /dev/null)

  function installBuild () {
    echo "updating ${message}..."
    cd "${buildPath}"
    find . -type f -exec install -Dm 755 -o "$USER" {} "${installPath}/$currentVersion"/{} \;
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

  installBuild
''
