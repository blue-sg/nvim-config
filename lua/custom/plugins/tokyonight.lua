return {
  "folke/tokyonight.nvim",
  priority = 1000,  -- ensure it loads first
  opts = {
    style = "storm",   -- choose: storm, night, moon, day
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },

  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight") -- auto loads the chosen style
  end,
}

