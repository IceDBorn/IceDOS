{
  config,
  ...
}:

let
  dns = "10.2.0.1";
  gateway = "192.168.1.1";
  interface = "enp1s0";
  ip = "192.168.1.4";
in
{
  services.resolved.enable = true;

  networking = {
    defaultGateway = {
      address = gateway;
      interface = interface;
    };

    firewall.enable = false;

    # Static IP
    interfaces = {
      ${interface} = {
        ipv4 = {
          addresses = [
            {
              address = ip;
              prefixLength = 24;
            }
          ];
        };
      };
    };

    nameservers = [ "9.9.9.9" ];

    # Enable vpn sharing
    nat = {
      enable = true;
      internalInterfaces = [ interface ];
    };
  };

  virtualisation.oci-containers = {
    backend =
      if (config.icedos.system.virtualisation.containerManager.usePodman) then "podman" else "docker";

    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        ports = [ "9443:9443" ];

        volumes = [
          "/run/podman/podman.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];

        extraOptions = [ "--pull=always" ];
      };

      stremio = {
        image = "stremio/server:latest";
        ports = [ "11470:11470" ];
        extraOptions = [ "--pull=always" ];
      };

      dnsmasq = {
        image = "dockurr/dnsmasq:latest";

        environment = {
          DNS1 = dns;
          DNS2 = dns;
        };

        ports = [ "${ip}:53:53/udp" ];
        extraOptions = [ "--pull=always" ];
      };

      wireguard = {
        image = "linuxserver/wireguard";
        extraOptions = [ "--pull=always" ];
        capabilities = { NET_ADMIN = true; };
        volumes = [ "/data/wireguard:/config" ];
        ports = [ "${ip}:51821:51821/udp" ];
      };

      nextcloud = {
        image = "nextcloud:29";
        extraOptions = [ "--pull=always" "--network=container:wireguard" ];
        dependsOn = [ "wireguard" ];
        volumes = [ "/data/nextcloud:/var/www/html" ];
      };

      # socks5 = {
      #   image = "serjs/go-socks5-proxy";
      #   extraOptions = [ "--pull=always" "--network=container:wireguard" ];
      #   dependsOn = [ "wireguard" ];
      # };
    };
  };
}
