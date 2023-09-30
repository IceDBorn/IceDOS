{ config, lib, ... }:

lib.mkIf config.applications.steam.session.enable {
  jovian.steam.enable = true;
}
