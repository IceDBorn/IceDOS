{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    aria
    (writeShellScriptBin "a2c" "aria2c -j 16 -s 16 $@")
  ];
}
