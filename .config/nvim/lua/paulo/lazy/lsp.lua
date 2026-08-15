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

      -- 1. Add vue_ls to the servers table so Mason installs it
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
        vue_ls = {}, -- Added Vue Language Server
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
            -- Use Mason Registry to get the EXACT path (works for Mason 1.x and 2.x)
            local mason_registry = require("mason-registry")
            local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"

            lspconfig.ts_ls.setup({
              capabilities = capabilities,
              filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
              init_options = {
                plugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "vue" },
                  },
                },
              },
              on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
              end,
            })
          end,
          -- EXPLICITLY configure vue_ls with cmd
          vue_ls = function()
            local lspconfig = require("lspconfig")
            lspconfig.vue_ls.setup({
              capabilities = capabilities,
              cmd = { "vue-language-server", "--stdio" }, -- Critical for v3+
              filetypes = { "vue" },
              on_attach = require("plugins.lsp.handlers").on_attach,
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
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
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

      vim.lsp.config("tailwindcss", {
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
      })

      -- Update ts_ls config to include vue filetypes here as well for vim.lsp.config
      vim.lsp.config("ts_ls", {
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
        settings = {
          typescript = { disableFormat = true },
          javascript = { disableFormat = true },
          vue = { disableFormat = true },
        },
        capabilities = {
          documentFormattingProvider = false,
          documentRangeFormattingProvider = false,
        },
        on_attach = function()
          -- Ensure vue_ls is enabled when ts_ls attaches to a vue file
          vim.lsp.enable({ "vue_ls" })
        end,
      })

      vim.lsp.enable({ "ts_ls" })
      -- Force ts_ls to attach to Vue files if mason-lspconfig skips it
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "vue",
        callback = function(args)
          local root_dir = vim.fs.root(args.buf, { "package.json", "tsconfig.json", "jsconfig.json" })

          -- Re-calculate path to ensure it's correct
          local mason_registry = require("mason-registry")
          local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"

          vim.lsp.start({
            name = "ts_ls",
            cmd = { "typescript-language-server", "--stdio" },
            root_dir = root_dir,
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                },
              },
            },
            capabilities = capabilities,
          })
        end,
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
