-- ~/.config/nvim/init.lua

-- Define a tecla leader (deve vir antes de carregar os plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Configurações básicas do Vim
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Configurações adicionais recomendadas
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"
vim.opt.clipboard = "unnamedplus"
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.o.showmode = false
vim.o.showcmd = false
vim.o.ruler = false

-- Map Ctrl+S para salvar no modo normal e no modo inserção
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

-- Carrega o lazy.nvim e os plugins
require("config.lazy")
