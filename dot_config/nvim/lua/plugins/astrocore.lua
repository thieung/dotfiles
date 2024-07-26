---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local tabpre = "<leader><tab>"
    local function yaml_ft(path, bufnr)
      local buf_text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
      if
        -- check if file is in roles, tasks, or handlers folder
        vim.regex("(tasks\\|roles\\|handlers)/"):match_str(path)
        -- check for known ansible playbook text and if found, return yaml.ansible
        or vim.regex("hosts:\\|tasks:"):match_str(buf_text)
      then
        return "yaml.ansible"
      elseif vim.regex("AWSTemplateFormatVersion:"):match_str(buf_text) then
        return "yaml.cfn"
      else -- return yaml if nothing else
        return "yaml"
      end
    end

    opts = require("astrocore").extend_tbl(opts, {
      -- Configure core features of AstroNvim
      features = {
        large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
        autopairs = true, -- enable autopairs at start
        cmp = true, -- enable completion at start
        -- diagnostics_mode = 0, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
        highlighturl = true, -- highlight URLs at start
        notifications = true, -- enable notifications at start
      },
      -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      diagnostics = {
        virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
        underline = true,
        update_in_insert = false,
      },
      filetypes = {
        extension = {
          mdx = "markdown.mdx",
          qmd = "markdown",
          yml = yaml_ft,
          yaml = yaml_ft,
        },
        filename = {
          ["docker-compose.yml"] = "yaml.docker-compose",
          ["docker-compose.yaml"] = "yaml.docker-compose",
        },
        pattern = {
          ["%.env%.[%w_.-]+"] = "sh",
          [".*/kitty/.+%.conf"] = "bash",
          ["/tmp/neomutt.*"] = "markdown",
        },
      },
      -- vim options can be configured here
      options = {
        opt = { -- vim.opt.<key>
          backup = false, -- Don't store backup while overwriting the file
          breakindent = true, -- Indent wrapped lines to match line start
          completeopt = "menuone,noinsert,noselect", -- Customize completions
          conceallevel = 1, -- enable conceal
          incsearch = true, -- Show search results while typing
          list = true, -- show whitespace characters
          listchars = { tab = "│→", extends = "⟩", precedes = "⟨", trail = "·", nbsp = "␣" },
          number = true, -- sets vim.opt.number
          relativenumber = true, -- sets vim.opt.relativenumber
          spell = false, -- sets vim.opt.spell
          signcolumn = "auto", -- sets vim.opt.signcolumn to auto
          showbreak = "↪",
          showtabline = (vim.t.bufs and #vim.t.bufs > 1) and 2 or 1,
          wrap = true, -- sets vim.opt.wrap
          writebackup = false, -- Don't store backup while overwriting the file
          pumblend = 10, -- Make builtin completion menus slightly transparent
          winblend = 10, -- Make floating windows slightly transparent
        },
        g = { -- vim.g.<key>
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },
      signs = {
        BqfSign = { text = " " .. require("astroui").get_icon "Selected", texthl = "BqfSign" },
      },
      autocmds = {
        auto_spell = {
          {
            event = "FileType",
            desc = "Enable wrap and spell for text like documents",
            pattern = { "gitcommit", "markdown", "text", "plaintex" },
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
            end,
          },
        },
        autohide_tabline = {
          {
            event = "User",
            desc = "Auto hide tabline",
            pattern = "AstroBufsUpdated",
            callback = function()
              local new_showtabline = #vim.t.bufs > 1 and 2 or 1
              if new_showtabline ~= vim.opt.showtabline:get() then vim.opt.showtabline = new_showtabline end
            end,
          },
        },
      },
      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = {
        n = {
          -- disable default bindings
          ["<C-Q>"] = false,
          ["q:"] = ":",
          -- navigate buffer tabs with `H` and `L`
          ["]b"] = false,
          ["[b"] = false,
          ["L"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["H"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

          -- better increment/decrement
          ["-"] = { "<C-x>", desc = "Descrement number" },
          ["+"] = { "<C-a>", desc = "Increment number" },

          ["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" },
          ["<leader>N"] = { "<cmd>tabnew<cr>", desc = "New Tab" },
          ["<leader>."] = { "<cmd>cd %:p:h<cr>", desc = "Set CWD" },

          -- tabs
          [tabpre] = { desc = "󰓩 Tab Managment" },
          [tabpre .. "l"] = { "<cmd>tablast<cr>", desc = "Last Tab" },
          [tabpre .. "f"] = { "<cmd>tabfirst<cr>", desc = "First Tab" },
          [tabpre .. "<tab>"] = { "<cmd>tabnew<cr>", desc = "New Tab" },
          [tabpre .. "]"] = { "<cmd>tabnext<cr>", desc = "Next Tab" },
          [tabpre .. "["] = { "<cmd>tabprevious<cr>", desc = "Previous Tab" },

          -- mappings seen under group name "Buffer"
          ["<Leader>bD"] = {
            function()
              require("astroui.status.heirline").buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<Leader>b"] = { desc = "Buffers" },
          -- quick save
          -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
        },
        i = {
          ["<C-S>"] = { function() vim.lsp.buf.signature_help() end, desc = "Signature Help" },
          ["<S-Tab>"] = { "<C-V><Tab>", desc = "Tab character" },
        },
        t = {
          ["<C-BS>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
          ["<Esc><Esc>"] = { "<C-\\><C-n>:q<CR>", desc = "Terminal quit" },
        },
        x = {
          ["<C-S>"] = false,
          -- better increment/decrement
          ["+"] = { "g<C-a>", desc = "Increment number" },
          ["-"] = { "g<C-x>", desc = "Descrement number" },
        },
      },
    }) --[[@as AstroCoreOpts]]

    -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    for lhs, rhs in pairs {
      n = { "'Nn'[v:searchforward]", expr = true, desc = "Next Search Result" },
      N = { "'nN'[v:searchforward]", expr = true, desc = "Prev Search Result" },
    } do
      opts.mappings.n[lhs] = rhs
      opts.mappings.x[lhs] = rhs
      opts.mappings.o[lhs] = rhs
    end

    -- add line text object
    for lhs, rhs in pairs {
      il = { ":<C-u>normal! $v^<CR>", desc = "inside line" },
      al = { ":<C-u>normal! V<CR>", desc = "around line" },
    } do
      opts.mappings.x[lhs] = rhs
    end

    -- add missing in between and around two character pairs
    for _, char in ipairs { "_", "-", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?" } do
      for lhs, rhs in pairs {
        ["i" .. char] = { (":<C-u>silent! normal! f%sF%slvt%s<CR>"):format(char, char, char), desc = "inside " .. char },
        ["a" .. char] = { (":<C-u>silent! normal! f%sF%svf%s<CR>"):format(char, char, char), desc = "around " .. char },
      } do
        opts.mappings.x[lhs] = rhs
      end
    end

    return opts
  end,
}
