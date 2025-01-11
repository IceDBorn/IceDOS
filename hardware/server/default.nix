{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce mkIf;
  cfg = config.icedos.hardware.devices.server;

  post-login = pkgs.writeShellScriptBin "post-install" ''
    mullvad auto-connect set on
    mullvad lan set allow
    mullvad relay set tunnel-protocol wireguard
    mullvad relay set location bg sof
    mullvad connect
    tailscale up
  '';
in
mkIf (cfg.enable) {
  environment.etc."resolv.conf" = mkForce {
    source = builtins.toFile "resolv.conf" "nameserver ${cfg.dns}";
    mode = "0644";
  };

  environment.systemPackages = [
    pkgs.dnsmasq
    post-login
  ];

  networking = {
    defaultGateway = {
      address = cfg.gateway;
      interface = cfg.interface;
    };

    firewall.enable = false;

    # Static IP
    interfaces = {
      ${cfg.interface} = {
        ipv4 = {
          addresses = [
            {
              address = cfg.ip;
              prefixLength = 24;
            }
          ];
        };
      };
    };

    # Enable vpn sharing
    nat = {
      enable = true;
      internalInterfaces = [ cfg.interface ];
    };

    networkmanager.enable = false;
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        resolv-file = "/etc/resolv.conf";
        listen-address = cfg.ip;
      };
    };

    mullvad-vpn.enable = true;
  };

  systemd.network.enable = false;

  virtualisation.oci-containers = {
    backend =
      if (config.icedos.system.virtualisation.containerManager.usePodman) then "podman" else "docker";

    containers = {
      portainer = {
        image = "portainer/portainer-ce:2.20.3";
        ports = [ "9443:9443" ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
      };

      stremio = {
        image = "stremio/server:v4.20.8";
        ports = [ "11470:11470" ];
      };

      tailscale = {
        image = "tailscale/tailscale:unstable-v1.71.44";
        volumes = [
          "tailscale:/var/lib"
          "/dev/net/tun:/dev/net/tun"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
        ];

        environment = {
          TS_ACCEPT_DNS = "true";
          TS_AUTH_ONCE = "true";
          TS_USERSPACE = "false";
          TS_STATE_DIR = "/var/lib/tailscale";
          TS_EXTRA_ARGS = "--accept-routes=true --advertise-exit-node";
          TS_AUTHKEY = "";
        };
      };
    };
  };
}
