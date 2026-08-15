return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
    },
    config = function()
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
      require("fidget").setup()
      require("mason").setup({})
      local servers = {
        biome = {},
        dockerls = {},
        docker_compose_language_service = {},
        lua_ls = {},
        pylsp = {},
        ruff = {},
        stylua = {},
        tailwindcss = {},
        ts_ls = {},
        vue_ls = {},
        zls = {},
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            local on_attach = require("plugins.lsp.handlers").on_attach
            require("lspconfig")[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
          ts_ls = function()
            local lspconfig = require("lspconfig")
            local on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
            end
            lspconfig.ts_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,
          lua_ls = function()
            local lspconfig = require("lspconfig")
            local on_attach = require("plugins.lsp.handlers").on_attach
            lspconfig.lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  completion = {
                    callSnippet = "Replace",
                  },
                  runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  diagnostics = {
                    globals = { "nvim" },
                  },
                  format = {
                    enabled = false,
                  },
                },
              },
            })
          end,
        },
      })
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<enter>"] = cmp.mapping.confirm({ select = true }),
          ["<C-space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.filetype({ "sql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      })

      local vue_ls_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      -- Configure TypeScript server with Vue plugin
      vim.lsp.config("ts_ls", {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_ls_path,
              languages = { "vue" },
            },
          },
        },
      }) -- Configure Vue Language Server
      vim.lsp.config("vue_ls", {
        filetypes = { "vue" },
        root_markers = { "package.json" },
        on_init = function(client)
          -- Hybrid mode handler to forward TSServer requests
          local retries = 0
          local function typescriptHandler(_, result, context)
            local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })[1]
            if not ts_client then
              if retries <= 10 then
                retries = retries + 1
                vim.defer_fn(function()
                  typescriptHandler(_, result, context)
                end, 100)
              else
                vim.notify("Could not find ts_ls client", vim.log.levels.ERROR)
              end
              return
            end
            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
              title = "vue_request_forward",
              command = "typescript.tsserverRequest",
              arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
              local response_data = { { id, r and r.body } }
              client:notify("tsserver/response", response_data)
            end)
          end
          client.handlers["tsserver/request"] = typescriptHandler
        end,
      })
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("pylsp", {
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
              flake8 = { enabled = false },
              mypy = { enabled = false },
              ruff = { enabled = true, formatEnabled = true },
            },
          },
        },
      })
      vim.diagnostic.config({
        update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        virtual_text = true,
      })
    end,
  },
}
