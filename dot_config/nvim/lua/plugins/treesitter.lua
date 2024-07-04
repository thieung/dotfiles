---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "RRethy/nvim-treesitter-endwise",
      event = "InsertEnter",
    },
    {
      "m-demare/hlargs.nvim",
      event = "BufReadPre",
      config = function() require("hlargs").setup() end,
      dependencies = "nvim-treesitter/nvim-treesitter",
    },
  },
  opts = function(_, opts)
    return {
      -- add more things to the ensure_installed table protecting against community packs modifying it
      ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "bash",
        "diff",
        "fish",
        "gitignore",
        "gitcommit",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "ruby",
        "query",
        "regex",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        -- add more arguments for adding more treesitter parsers
      }),
      indent = {
        enable = false, -- Dont enable this or it'll messup indentation when a period is added to a class
      },
      textobjects = {
        -- https://github.com/chrisgrieser/nvim-various-textobjs#list-of-text-objects
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ab"] = { query = "@block.outer", desc = "around block" },
            ["ib"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]b"] = { query = "@block.outer", desc = "Next block start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
          },
          goto_next_end = {
            ["]B"] = { query = "@block.outer", desc = "Next block end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[b"] = { query = "@block.outer", desc = "Previous block start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
          },
          goto_previous_end = {
            ["[B"] = { query = "@block.outer", desc = "Previous block end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
          },
        },
      },
      endwise = {
        enable = true,
      },
    }
  end,
}
