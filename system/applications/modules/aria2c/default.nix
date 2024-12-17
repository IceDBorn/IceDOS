{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.aria ];

  programs.zsh.shellAliases.a2c = "aria2c -j 16 -s 16";
}
