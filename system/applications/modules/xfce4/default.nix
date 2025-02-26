{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) toJSON;
  inherit (lib) attrNames baseNameOf concatStrings isPath isString length map mapAttrs mkIf xor;
  cfg = config.icedos;

  files = cfg.internals.xfce4.files;
  fileNames = attrNames files;
  filesExist = length fileNames > 0;

  xfce4FilesScript =
    map
    (file: ''
      mkdir -p $out/$(dirname "${file}")
      ${
        if (files.${file}.source == null)
        then "ln -s ${with builtins; toFile (baseNameOf file) files.${file}.text} ${file}"
        else "ln -s ${files.${file}.source} ${file}"
      }
    '')
    fileNames;

  xfce4Files = pkgs.runCommand "xfce4Files" {} ''
    mkdir -p $out ; cd $out
    ${concatStrings xfce4FilesScript}
  '';
in
mkIf (filesExist) {
  assertions = map
    (file:
      let
        inherit (files.${file}) source text;
      in {
        assertion = (xor (source != null) (text != null)) && ((isPath source) || (isString text));
        message = ''
          Please set only "${file}".source to a file path, or "${file}".text to a string.
          Current value: ${toJSON files.${file}}.
        '';
      })
    fileNames;

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.system.users.${user}.type != "server") {
      ".config/xfce4" = {
        source = xfce4Files;
      };
    };
  }) cfg.system.users;
}
