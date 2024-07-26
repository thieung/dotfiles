---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
  dependencies = { "williamboman/mason.nvim" },
  init = function(plugin) require("astrocore").on_load("mason.nvim", plugin.name) end,
  opts = {
    ensure_installed = {
      -- Language Servers
      "gopls",
      "json-lsp",
      "lua-language-server",
      "markdown-oxide",
      "sqls",
      "tailwindcss-language-server",
      "vtsls",
      "yaml-language-server",
      "solargraph",
      "dockerfile-language-server",
      "bash-language-server",

      -- Linters
      "ansible-lint",
      "selene",
      "shellcheck",
      "sqlfluff",
      "yamllint",
      "markdownlint",

      -- Formatters
      "prettier",
      "shfmt",
      "stylua",

      -- Debuggers
      "delve",
    },
    integrations = {
      ["mason-lspconfig"] = false,
      ["mason-nvim-dap"] = false,
    },
  },
  config = function(_, opts)
    local mason_tool_installer = require "mason-tool-installer"
    mason_tool_installer.setup(opts)
    mason_tool_installer.run_on_start()
  end,
  specs = {
    { "jay-babu/mason-nvim-dap.nvim", optional = true, init = false },
    { "williamboman/mason-lspconfig.nvim", optional = true, init = false },
    { "jay-babu/mason-null-ls.nvim", optional = true, init = false },
  },
}
