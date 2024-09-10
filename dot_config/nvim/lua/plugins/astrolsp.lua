---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = { signature_help = true },
    autocmds = {
      no_insert_inlay_hints = {
        cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
        {
          event = "InsertEnter",
          desc = "disable inlay hints on insert",
          callback = function(args)
            local filter = { bufnr = args.buf }
            if vim.lsp.inlay_hint.is_enabled(filter) then
              vim.lsp.inlay_hint.enable(false, filter)
              vim.api.nvim_create_autocmd("InsertLeave", {
                buffer = args.buf,
                once = true,
                callback = function() vim.lsp.inlay_hint.enable(true, filter) end,
              })
            end
          end,
        },
      },
    },
    config = {
      gopls = {
        settings = {
          gopls = {
            codelenses = {
              generate = true, -- show the `go generate` lens.
              gc_details = true, -- Show a code lens toggling the display of gc's choices.
              test = true,
              tidy = true,
              vendor = true,
              regenerate_cgo = true,
              upgrade_dependency = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            semanticTokens = true,
          },
        },
      },
      lua_ls = { settings = { Lua = { hint = { enable = true, arrayIndex = "Disable" } } } },
      vtsls = {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = "always" },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = "always" },
          },
        },
      },
      ruby_lsp = {
        root_dir = function(fname)
          return require("lspconfig").util.root_pattern("Gemfile", ".git")(fname) or vim.fn.getcwd()
        end,
        settings = {
          init_options = {
            enabledFeatures = {
              formatting = false,
            },
          },
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      i = {
        ["<C-l>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Signature help",
          cond = "textDocument/signatureHelp",
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
