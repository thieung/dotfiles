local prefix = "<Leader>r"
local send_cell = function(go_to_next)
  local cmd = go_to_next and "<Plug>SlimeCellsSendAndGoToNext" or "<Plug>SlimeSendCell"
  return function()
    if vim.g.slime_cell_delimiter or vim.b.slime_cell_delimiter then
      return cmd
    else
      return "<cmd>lua vim.notify('No cell configured')<CR>"
    end
  end
end
local nav_cell = function(dir)
  local cmd = dir > 0 and "<Plug>SlimeCellsNext" or "<Plug>SlimeCellsPrev"
  return function()
    if vim.g.slime_cell_delimiter or vim.b.slime_cell_delimiter then
      return cmd
    else
      return "<cmd>lua vim.notify('No cell configured')<CR>"
    end
  end
end
return {
  "jpalardy/vim-slime",
  cmd = { "SlimeConfig", "SlimeSend", "SlimeSend0", "SlimeSend1", "SlimeSendCurrentLine" },
  keys = {
    "<Plug>SlimeMotionSend",
    "<Plug>SlimeParagraphSend",
    "<Plug>SlimeLineSend",
    "<Plug>SlimeSendCell",
    "<Plug>SlimeConfig",
    { "<Plug>SlimeRegionSend", mode = { "n", "x" } },
    "<Plug>SlimeCellsSendAndGoToNext",
    "<Plug>SlimeCellsNext",
    "<Plug>SlimeCellsPrev",
  },
  dependencies = {
    "klafyvel/vim-slime-cells",
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        options = {
          g = {
            slime_target = "kitty",
            slime_bracketed_paste = true,
            slime_no_mappings = true,
            slime_cell_delimiter = "^\\s*# %%",
          },
        },
        mappings = {
          n = {
            [prefix] = { desc = " REPL" },
            [prefix .. "r"] = { "<Plug>SlimeMotionSend", desc = "Send to REPL" },
            [prefix .. "c"] = { send_cell(), expr = true, desc = "Send cell to REPL" },
            [prefix .. "C"] = { send_cell(true), expr = true, desc = "Send cell to REPL and go to next" },
            [prefix .. "p"] = { "<Plug>SlimeParagraphSend", desc = "Send paragraph to REPL" },
            [prefix .. "l"] = { "<Plug>SlimeLineSend", desc = "Send line to REPL" },
            [prefix .. "<CR>"] = { "<Cmd>SlimeConfig<CR>", desc = "Configure REPL" },
            ["<C-C>"] = { "<Plug>SlimeMotionSend", desc = "Send to REPL" },
            ["<C-C><C-C>"] = { send_cell(), expr = true, desc = "Send cell to REPL" },
            ["<C-C><C-X>"] = { send_cell(true), expr = true, desc = "Send cell to REPL and go to next" },
            ["<C-C><C-P>"] = { "<Plug>SlimeParagraphSend", desc = "Send paragraph to REPL" },
            ["<C-C><C-L>"] = { "<Plug>SlimeLineSend", desc = "Send line to REPL" },
            ["]c"] = { nav_cell(1), expr = true, desc = "Next slime cell" },
            ["[c"] = { nav_cell(-1), expr = true, desc = "Previous slime cell" },
          },
          x = {
            ["<C-C>"] = { "<Plug>SlimeRegionSend", desc = "Send region to REPL" },
          },
        },
        autocmds = {
          slime_cells = {
            {
              event = "FileType",
              pattern = "markdown",
              callback = function(args) vim.b[args.buf].slime_cell_delimiter = "^\\s*```" end,
            },
          },
        },
      },
    },
  },
}
