{ config, lib, ... }:

lib.mkIf config.applications.steam.session {
  jovian.steam.enable = true;
}
