return {
  "echasnovski/mini.icons",
  opts = {
    file = {
      [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
      [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
      [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
      [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
      ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
      ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
      ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
      ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
      ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
    },
    filetype = {
      gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      ["hcl.packer"] = { glyph = "", hl = "MiniIconsAzure" },
    },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  specs = {
    { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        default_component_configs = {
          icon = {
            provider = function(icon, node)
              local text, hl
              local mini_icons = require "mini.icons"
              if node.type == "file" then
                text, hl = mini_icons.get("file", node.name)
              elseif node.type == "directory" then
                text, hl = mini_icons.get("directory", node.name)
                if node:is_expanded() then text = nil end
              end

              if text then icon.text = text end
              if hl then icon.highlight = hl end
            end,
          },
          kind_icon = {
            provider = function(icon, node)
              icon.text, icon.highlight = require("mini.icons").get("lsp", node.extra.kind.name)
            end,
          },
        },
      },
    },
  },
}
