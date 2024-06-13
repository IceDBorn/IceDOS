{ config, lib, ... }:
let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;

        formatOnSave =
          if (cfg.system.users.${user}.applications.nvchad.formatOnSave) then
            ''
              -- Format on sav
              vim.cmd [[
                  augroup format_on_save
                    autocmd!
                    autocmd BufWritePre * lua vim.lsp.buf.format({ async = true })
                  augroup end
              ]]
            ''
          else
            "";
      in
      {
        ${username}.home.file.".config/nvim/lua/custom/init.lua".text = ''
            -- Enable blinking
          vim.o.guicursor =
            "a:ver25-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,n-v:block,r-cr:hor25,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"

          -- auto-session
          vim.o.sessionoptions = "blank,buffers,curdir,winsize,localoptions,tabpages"

          -- Fix tabufline compatibility with auto-session
          vim.api.nvim_create_autocmd({ "BufEnter" }, {
            callback = function()
              vim.t.bufs = vim.api.nvim_list_bufs()
            end,
          })

          ${formatOnSave}
        '';
      }
    ) users;
}
