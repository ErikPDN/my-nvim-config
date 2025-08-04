return {
  -- BLOCO 1: MASON
  -- Responsável apenas por existir e gerenciar os pacotes.
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
  -- Responsável por garantir que os LSPs estejam instalados via Mason.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
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
        },
        -- Configuração automática usando vim.lsp.config (API moderna)
        handlers = {
          -- Handler padrão para todos os servidores
          function(server_name)
            vim.lsp.config[server_name] = {
              -- Configurações básicas comuns
              capabilities = require('mason-lspconfig').get_capabilities(),
            }
            vim.lsp.enable(server_name)
          end,

          -- Handler específico para lua_ls
          ["lua_ls"] = function()
            vim.lsp.config.lua_ls = {
              capabilities = require('mason-lspconfig').get_capabilities(),
              settings = {
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    globals = { 'vim' }, -- Reconhece 'vim' como global
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
            }
            vim.lsp.enable('lua_ls')
          end,

          -- Handler específico para jdtls (Java)
          ["jdtls"] = function()
            -- Para Java, é melhor usar nvim-jdtls plugin separadamente
            -- Aqui apenas configuramos básico
            vim.lsp.config.jdtls = {
              capabilities = require('mason-lspconfig').get_capabilities(),
              root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
            }
            vim.lsp.enable('jdtls')
          end,
        },
      })
    end,
  },

  -- BLOCO 3: NVIM-LSPCONFIG
  -- Para configurações adicionais e keymaps
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Configuração de keymaps e autocommands
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf

          -- Keymaps específicos para buffers com LSP
          local opts = { buffer = bufnr, silent = true }

          -- Navegação
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

          -- Informações
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

          -- Ações
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

          -- Formatação
          if client and client:supports_method('textDocument/formatting') then
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end, opts)

            -- Auto-formatação ao salvar (opcional)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
              end,
            })
          end

          -- Ativar completion se suportado
          if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
          end

          -- Highlight de referências
          if client and client:supports_method('textDocument/documentHighlight') then
            local highlight_group = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Configuração de diagnósticos
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        float = {
          source = "always",
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Keymaps para diagnósticos
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Set diagnostic loclist' })
    end,
  },
}
