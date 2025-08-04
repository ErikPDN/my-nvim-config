return {
  "akinsho/toggleterm.nvim",
  version = "*", -- ou use uma tag de versão específica como 'v2.9.0'
  config = function()
    require("toggleterm").setup({
      size = 6,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,

      float_opts = {
        border = 'curved',
        winblend = 0,
      }
    })

    -- Função para definir atalhos específicos do terminal
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      -- Mapeamento para voltar ao modo Normal dentro do terminal
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- Executa a função acima sempre que um terminal for aberto
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    -- Criando terminais customizados com atalhos
    local Terminal = require("toggleterm.terminal").Terminal

    -- Terminal flutuante para comandos rápidos
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = vim.fn.getcwd(),
      direction = "float",
      hidden = true,
      float_opts = {
        border = "double",
      },
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })

    function _G.lazygit_toggle()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua lazygit_toggle()<CR>",
      { noremap = true, silent = true, desc = "ToggleTerm: Lazygit" })
  end,
}
