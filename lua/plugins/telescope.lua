-- ~/.config/nvim/lua/plugins/telescope.lua

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Opcional: melhora a performance de busca
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "truncate" },
					-- Mapeamentos dentro do telescope
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- mover para cima
							["<C-j>"] = actions.move_selection_next, -- mover para baixo
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-c>"] = actions.close,
							["<Esc>"] = actions.close,
						},
						n = {
							["<Esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,
							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["G"] = actions.move_to_bottom,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["?"] = actions.which_key,
						},
					},
				},

				pickers = {
					-- Configurações específicas para cada picker
					find_files = {
						-- `hidden = true` vai mostrar arquivos ocultos (dotfiles)
						-- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
					live_grep = {
						additional_args = function(opts)
							return { "--hidden" }
						end,
					},
				},

				extensions = {
					-- Configuração da extensão fzf (se instalada)
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Carrega extensões
			pcall(require("telescope").load_extension, "fzf")

			-- Keymaps do Telescope
			local builtin = require("telescope.builtin")

			-- Busca de arquivos
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Telescope grep string under cursor" })

			-- LSP (Language Server Protocol)
			vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "Telescope LSP references" })
			vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "Telescope LSP definitions" })
			vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Telescope LSP document symbols" })
			vim.keymap.set(
				"n",
				"<leader>lw",
				builtin.lsp_workspace_symbols,
				{ desc = "Telescope LSP workspace symbols" }
			)

			-- Outros
			vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Telescope marks" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
			vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "Telescope colorschemes" })
			vim.keymap.set("n", "<leader>fo", builtin.vim_options, { desc = "Telescope vim options" })
			vim.keymap.set(
				"n",
				"<leader>f/",
				builtin.current_buffer_fuzzy_find,
				{ desc = "Telescope search in current buffer" }
			)

			-- Busca em arquivos específicos
			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Telescope find neovim config files" })

			-- Busca com preview
			vim.keymap.set("n", "<leader>fp", function()
				builtin.find_files({ previewer = true })
			end, { desc = "Telescope find files with preview" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
