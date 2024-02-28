return {
  "nvim-treesitter/nvim-treesitter", -- Smarter code understanding like syntax Highlight and navigation
  build = ":TSUpdate",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = "BufReadPre",
      config = true,
    },
    {
      "HiPhish/nvim-ts-rainbow2",
      config = function()
        require("nvim-treesitter.configs").setup {
          rainbow = {
            enable = true,
            query = "rainbow-parens", -- which query to use for finding delimiters
            strategy = require "ts-rainbow.strategy.global", -- highlight the entire buffer all at once
          },
        }
        vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, {
          callback = function()
            vim.cmd.TSDisable "rainbow"
            vim.cmd.TSEnable "rainbow"
          end,
        })
      end,
    },
    {
      "windwp/nvim-ts-autotag", -- Autoclose and autorename HTML and Vue tags
      config = true,
    },
    {
      "Wansmer/treesj",
      opts = {
        use_default_keymaps = false,
      },
    },
    "RRethy/nvim-treesitter-endwise", -- Automatically add end keywords for Ruby, Lua, Python, and more
    {
      "andymass/vim-matchup",
      event = "BufReadPost",
      config = function() vim.g.matchup_matchparen_offscreen = { method = "status_manual" } end,
    },
  },
  opts = {
    ensure_installed = {
      "bash",
      "diff",
      "fish",
      "gitignore",
      "gitcommit",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = "<nop>",
        node_decremental = "<bs>",
      },
    },
    auto_install = vim.fn.executable "tree-sitter" == 1,
    highlight = { disable = { "help" } },
    indent = { enable = true },
    rainbow = { enable = true },
    endwise = { enable = true },
    autotag = { enable = true },
    matchup = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          aA = "@attribute.outer",
          iA = "@attribute.inner",
          aB = "@block.outer",
          iB = "@block.inner",
          aD = "@conditional.outer",
          iD = "@conditional.inner",
          aF = "@function.outer",
          iF = "@function.inner",
          aL = "@loop.outer",
          iL = "@loop.inner",
          aP = "@parameter.outer",
          iP = "@parameter.inner",
          aR = "@regex.outer",
          iR = "@regex.inner",
          aX = "@class.outer",
          iX = "@class.inner",

          aS = "@statement.outer",
          iS = "@statement.outer",
          aN = "@number.inner",
          iN = "@number.inner",
          aC = "@comment.outer",
          iC = "@comment.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]b"] = { query = "@block.outer", desc = "Next block start" },
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]p"] = { query = "@parameter.outer", desc = "Next parameter start" },
          ["]x"] = { query = "@class.outer", desc = "Next class start" },
          ["]c"] = { query = "@comment.outer", desc = "Next comment start" },
        },
        goto_next_end = {
          ["]B"] = { query = "@block.outer", desc = "Next block end" },
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]P"] = { query = "@parameter.outer", desc = "Next parameter end" },
          ["]X"] = { query = "@class.outer", desc = "Next class end" },
          ["]C"] = { query = "@comment.outer", desc = "Next comment end" },
        },
        goto_previous_start = {
          ["[b"] = { query = "@block.outer", desc = "Previous block start" },
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[p"] = { query = "@parameter.outer", desc = "Previous parameter start" },
          ["[x"] = { query = "@class.outer", desc = "Previous class start" },
          ["[c"] = { query = "@comment.outer", desc = "Previous comment start" },
        },
        goto_previous_end = {
          ["[B"] = { query = "@block.outer", desc = "Previous block end" },
          ["[F"] = { query = "@function.outer", desc = "Previous function end" },
          ["[P"] = { query = "@parameter.outer", desc = "Previous parameter end" },
          ["[X"] = { query = "@class.outer", desc = "Previous class end" },
          ["[C"] = { query = "@comment.outer", desc = "Previous comment end" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          [">B"] = { query = "@block.outer", desc = "Swap next block" },
          [">F"] = { query = "@function.outer", desc = "Swap next function" },
          [">P"] = { query = "@parameter.inner", desc = "Swap next parameter" },
        },
        swap_previous = {
          ["<B"] = { query = "@block.outer", desc = "Swap previous block" },
          ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
          ["<P"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
        },
      },
    },
  },
}
