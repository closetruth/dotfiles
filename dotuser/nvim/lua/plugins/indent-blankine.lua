return { 
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowOrange",
      "RainbowYellow",
      "RainbowGreen",
      "RainbowCyan",
      "RainbowBlue",
      "RainbowViolet",
    }
    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#CC0000" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D06200" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#656500" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#008800" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#688700" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#0200D3" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#6700AA" })
    end)
    require("ibl").setup { indent = { highlight = highlight } }
  end,
}
