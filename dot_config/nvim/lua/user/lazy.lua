return function(config)
  return require("astronvim.utils").extend_tbl(config, {
    defaults = { lazy = true },
    checker = { enabled = true }, -- automatically check for plugin updates
    performance = {
      cache = {
        enabled = true,
      },
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    diff = { cmd = "terminal_git" },
  })
end
