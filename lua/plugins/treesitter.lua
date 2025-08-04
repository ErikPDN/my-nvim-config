-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
	},
	config = function()
		-- Proteção para casos onde o treesitter não está disponível
		local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			vim.notify("nvim-treesitter not found!")
			return
		end

		treesitter.setup({
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"python",
				"rust",
				"go",
				"java",
				"php",
				"sql",
				"regex",
				"toml",
			},

			-- Instalar parsers automaticamente (apenas se não estiverem instalados)
			auto_install = true,

			-- Não instalar estes parsers
			ignore_install = {},

			-- Configurações de highlighting
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},

			-- Indentação automática baseada no Tree-sitter
			indent = {
				enable = true,
				disable = { "yaml" }, -- YAML tem problemas com indentação automática
			},

			-- Seleção incremental
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<M-space>",
				},
			},

			-- Text objects para navegação e seleção
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Pula automaticamente para o próximo text object
					keymaps = {
						-- Você pode usar os capture groups definidos em textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ii"] = "@conditional.inner",
						["ai"] = "@conditional.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["at"] = "@comment.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- se deve definir jumps na jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
						["]o"] = "@loop.*",
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
					goto_next = {
						["]d"] = "@conditional.outer",
					},
					goto_previous = {
						["[d"] = "@conditional.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},

			-- Folding (dobrar código)
			fold = {
				enable = true,
				disable = {},
			},
		})

		-- Configuração do Tree-sitter Context (mostra contexto da função atual)
		local context_status_ok, context = pcall(require, "treesitter-context")
		if context_status_ok then
			context.setup({
				enable = true,
				max_lines = 0, -- 0 = sem limite
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})
		end

		-- Keymaps adicionais
		local keymap = vim.keymap.set

		-- Toggle Tree-sitter highlighting
		keymap("n", "<leader>th", "<cmd>TSToggle highlight<cr>", { desc = "Toggle Tree-sitter highlighting" })

		-- Tree-sitter info
		keymap("n", "<leader>ti", "<cmd>TSConfigInfo<cr>", { desc = "Tree-sitter config info" })

		-- Toggle context (comando correto)
		keymap("n", "<leader>tc", function()
			local context_status_ok, context = pcall(require, "treesitter-context")
			if context_status_ok then
				context.toggle()
			else
				vim.notify("treesitter-context not available")
			end
		end, { desc = "Toggle Tree-sitter context" })

		-- Folding baseado no Tree-sitter
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldenable = false -- Não dobrar por padrão ao abrir arquivos
	end,
}
