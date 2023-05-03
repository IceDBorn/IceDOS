-- Enable blinking
vim.o.guicursor = 'a:ver25-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,n-v:block,r-cr:hor25,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175'

-- auto-session
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Fix nvimtree when restoring session
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'NvimTree*',
  callback = function()
    local api = require('nvim-tree.api')

    if not api.tree.is_visible() then
      api.tree.open()
    end
  end,
})

