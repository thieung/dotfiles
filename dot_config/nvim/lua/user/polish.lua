vim.filetype.add {
  extension = {
    lock = "yaml",
  },
  filename = {
    ["go.mod"] = "gomod",
    ["sketchybarrc"] = "sh",
  },
  pattern = {
    [".*%.conf"] = "conf",
    [".*%.env%..*"] = "env",
  },
}

require "user.autocmds"
