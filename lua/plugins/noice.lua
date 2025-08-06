return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- sobrescrever markdown rendering para que **cmp** e outras plugins usem **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requer hrsh7th/nvim-cmp
				},
				-- mostrar informações de progresso do LSP
				progress = {
					enabled = true,
					-- formato da mensagem de progresso
					format = "lsp_progress",
					-- formato quando o progresso está inativo
					format_done = "lsp_progress_done",
					throttle = 1000 / 30, -- frequência de atualização
					view = "mini",
				},
				-- configurar hover e signature help
				hover = {
					enabled = true,
					silent = false, -- definir como true para não mostrar mensagem se hover não estiver disponível
					view = nil, -- quando nil, usar defaults
					opts = {}, -- opções passadas para nvim_open_win
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true, -- Auto mostrar signature help ao digitar um trigger character do LSP
						luasnip = true, -- Mostrar signature help ao pular/expandir snippet
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
					view = nil, -- quando nil, usar defaults
					opts = {}, -- opções passadas para nvim_open_win
				},
				message = {
					-- Mensagens mostradas pelo lsp servers
					enabled = true,
					view = "notify",
					opts = {},
				},
				-- defaults para hover e signature help
				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						win_options = { concealcursor = "n", conceallevel = 3 },
					},
				},
			},
			presets = {
				-- usar um classic bottom cmdline para pesquisa
				bottom_search = true,
				-- usar um command palette style cmdline
				command_palette = true,
				-- long messages serão enviadas para um split
				long_message_to_split = true,
				-- habilitar um border para hover docs e signature help
				lsp_doc_border = false,
			},
			-- configurações para diferentes views
			views = {
				cmdline_popup = {
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 8,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			},
			-- configurar roteamento de mensagens
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
				-- redirecionar mensagens de write para mini view
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
				-- redirecionar mensagens longas para split
				{
					filter = {
						event = "msg_show",
						min_height = 20,
					},
					view = "split",
				},
			},
			-- configurações de notificação
			notify = {
				-- Noice pode ser usado como vim.notify para que você obtenha um melhor default
				enabled = true,
				view = "notify",
			},
			-- configurações da cmdline
			cmdline = {
				enabled = true, -- habilita UI cmdline do Noice
				view = "cmdline_popup", -- view para renderizar a cmdline. Mude para `cmdline` para obter um cmdline classic na parte inferior
				opts = {}, -- opções globais para a cmdline. Veja seção sobre views
				format = {
					-- formatação concise para diferentes tipos de comandos
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = {}, -- Usado por input()
				},
			},
			-- configurações de mensagens
			messages = {
				-- NOTA: Se você habilitar messages, então a cmdline é automaticamente habilitada.
				enabled = true, -- habilita o UI messages do Noice
				view = "notify", -- default view para messages
				view_error = "notify", -- view para errors
				view_warn = "notify", -- view para warnings
				view_history = "messages", -- view para :messages
				view_search = "virtualtext", -- view para search count messages. Defina como `false` para desabilitar
			},
			-- configurações de popupmenu
			popupmenu = {
				enabled = true, -- habilita o popupmenu do Noice
				backend = "nui", -- backend para usar para mostrar o popupmenu. Valores possíveis: "nui" ou "cmp"
				kind_icons = {}, -- definir como `false` para desabilitar icons
			},
			-- configurações padrão para hover e signature help
			redirect = {
				view = "popup",
				filter = { event = "msg_show" },
			},
			-- você pode habilitar um scrollbar para views que suportam
			throttle = 1000 / 30, -- como frequentemente o Noice precisa verificar por updates. Isso afeta a suavidade das animações.
		},
		dependencies = {
			-- se você lazy-load qualquer plugin abaixo, certifique-se de adicionar entradas `module="..."` apropriadas
			"MunifTanjim/nui.nvim",
			-- OPCIONAL:
			--   `nvim-notify` é necessário apenas se você quiser usar a notification view.
			--   Se não disponível, usamos `mini` como fallback
			"rcarriga/nvim-notify",
		},
		config = function(_, opts)
			require("noice").setup(opts)
			
			-- Keymaps opcionais para o Noice
			vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
				if not require("noice.lsp").scroll(4) then
					return "<c-f>"
				end
			end, { silent = true, expr = true, desc = "Scroll forward" })

			vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
				if not require("noice.lsp").scroll(-4) then
					return "<c-b>"
				end
			end, { silent = true, expr = true, desc = "Scroll backward" })
		end,
	},
}
