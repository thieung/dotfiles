return {
  { "AstroNvim/astrocommunity" }, -- loading community plugins

  { import = "astrocommunity.editing-support.zen-mode-nvim", enabled = true },
  -- { import = "astrocommunity.utility.neodim", enabled = false },
  { import = "astrocommunity.motion.mini-surround", enabled = true },
  { import = "astrocommunity.motion.leap-nvim", enabled = true },

  { import = "user.plugins.pack.ruby.ruby", enabled = true },
  { import = "astrocommunity.pack.go", enabled = true },
  { import = "astrocommunity.pack.lua", enabled = true },
  { import = "astrocommunity.pack.markdown", enabled = true },

  -- motion
  { import = "astrocommunity.motion.mini-move", enabled = true },
}
