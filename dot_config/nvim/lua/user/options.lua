return {
  opt = {
    conceallevel = 2, -- enable conceal
    backup = false, -- Don't store backup while overwriting the file
    incsearch = true, -- Show search results while typing
    list = true, -- show whitespace characters
    listchars = { tab = "│→", extends = "⟩", precedes = "⟨", trail = "·", nbsp = "␣" },
    showbreak = "↪ ",
    wrap = true, -- soft wrap lines
    completeopt = "menuone,noinsert,noselect", -- Customize completions
    formatoptions = "qjl1", -- Don't autoformat comments
    pumblend = 10, -- Make builtin completion menus slightly transparent
    winblend = 10, -- Make floating windows slightly transparent
  },
  g = {
    lsp_handlers_enabled = false,
    matchup_matchparen_deferred = 1,
    resession_enabled = false, -- using "Shatur/neovim-session-manager"
  },
}
