{ config, lib, ... }:

lib.mkIf config.desktop-environment.steam.session.enable {
  jovian.steam = {
    enable = true;
    useStockEnvironment = true;
  };
}
