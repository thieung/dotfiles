---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        always_show = { ".github", ".gitignore" },
      },
    },
    nesting_rules = {
      docker = {
        pattern = "^dockerfile$",
        ignore_case = true,
        files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
      },
      git_files = {
        pattern = "^%.gitignore$",
        files = { ".gitattributes", ".gitmodules", ".gitmessage", ".mailmap", ".git-blame*" },
      },
      readme = {
        pattern = "^readme.*",
        ignore_case = true,
        files = {
          "authors",
          "backers*",
          "changelog*",
          "citation*",
          "code_of_conduct*",
          "codeowners",
          "contributing*",
          "contributors",
          "copying*",
          "credits",
          "governance.md",
          "history.md",
          "license*",
          "maintainers",
          "readme*",
          "security.md",
          "sponsors*",
        },
      },
      tool_versions = {
        pattern = "^%.tool-versions$",
        files = { ".rtx.toml" },
      },
    },
  },
}
