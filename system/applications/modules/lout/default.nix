{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "lout" ''
      pkill -KILL -u $USER
    '')
  ];
}
