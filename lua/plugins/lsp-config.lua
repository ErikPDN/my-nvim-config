return {
    -- BLOCO 1: MASON
    -- Instala e gerencia os LSPs, Linters e Formatadores.
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- BLOCO 2: MASON-LSPCONFIG
    -- Faz a ponte entre o Mason (instalador) e o nvim-lspconfig (configurador).
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require("mason-lspconfig").setup({
                -- Lista de servidores LSP para garantir que estejam instalados.
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ts_ls",
                    "html",
                    "cssls",
                    "jsonls",
                    "yamlls",
                    "bashls",
                    "marksman",
                    "jdtls",
                    "tailwindcss",
                },
                -- Configuração dos handlers para cada servidor.
                handlers = {
                    function(server_name)
                      vim.lsp.config(server_name, {
                        capabilities = capabilities
                      })
                      vim.lsp.enable(server_name)
                    end,

                    -- Configuração específica para o lua_ls.
                    ["lua_ls"] = function()
                        -- Usamos vim.lsp.config() para estender a configuração padrão.
                        vim.lsp.config("lua_ls", {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = { version = "LuaJIT" },
                                    diagnostics = { globals = { "vim" } },
                                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                        vim.lsp.enable("lua_ls")
                    end,

                    -- jdtls também pode ter configurações específicas se necessário.
                    ["jdtls"] = function()
                        vim.lsp.config("jdtls", {
                            capabilities = capabilities,
                        })
                        vim.lsp.enable("jdtls")
                    end,
                },
            })
        end,
    },

    -- BLOCO 3: NVIM-LSPCONFIG
    -- Este plugin agora serve principalmente para fornecer as configs padrão.
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = { "mason-org/mason-lspconfig.nvim" },
        config = function()
            -- Esta parte do seu código já estava excelente e segue as melhores práticas!
            -- Define atalhos e configurações de UI quando um servidor LSP é anexado a um buffer.

            -- Configurações globais de diagnóstico (sinais, texto virtual, etc.)
            vim.diagnostic.config({
                virtual_text = { prefix = "●", source = "if_many" },
                float = { source = "always", border = "rounded" },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Atalhos para navegação de diagnósticos
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set diagnostic loclist" })

            -- Gatilho para configurar atalhos específicos do LSP
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(event)
                    local bufnr = event.buf
                    local opts = { buffer = bufnr, silent = true }

                    -- Mapeamentos de teclas para ações do LSP
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            })
        end,
    },
}
