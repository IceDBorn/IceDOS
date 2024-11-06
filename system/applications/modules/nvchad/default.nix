{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
{
  imports = [ ./init.nix ];

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.applications.nvchad) [
      beautysh # Bash formatter
      black # Python formatter
      eslint # An AST-based pattern checker for JavaScript
      libclang # C language server and formatter
      lua-language-server # Lua language server
      marksman # Markdown language server
      nil # Nix language server
      nodePackages.bash-language-server # Bash Language server
      nodePackages.dockerfile-language-server-nodejs # Dockerfiles language server
      nodePackages.prettier # Javascript/Typescript formatter
      nodePackages.typescript-language-server # Typescript language server
      nodePackages.vscode-langservers-extracted # HTML, CSS, Eslint, Json language servers
      python3Packages.jedi-language-server # Python language server
      ripgrep # Silver searcher grep
      rust-analyzer # Rust language server
      rustfmt # Rust formatter
      shellcheck # Shell script analysis tool
      stylua # Lua formatter
      tailwindcss-language-server # Tailwind language server
      tree-sitter # Parser generator tool and an incremental parsing library
    ];

  programs = mkIf (cfg.applications.nvchad) {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    zsh.shellAliases.n = "tmux a -t nvchad || tmux new -s nvchad nvim";
  };

  home-manager.users = mapAttrs (user: _: {
    home.file = mkIf (cfg.applications.nvchad) {
      ".config/nvim" = {
        source = pkgs.nvchad;
        recursive = true;
      };

      ".config/nvim/lua/custom/configs" = {
        source = ./configs;
        recursive = true;
      };

      ".config/nvim/lua/custom/chadrc.lua".source = ./chadrc.lua;
      ".config/nvim/lua/custom/mappings.lua".source = ./mappings.lua;
      ".config/nvim/lua/custom/plugins.lua".source = ./plugins.lua;
    };
  }) cfg.system.users;
}
