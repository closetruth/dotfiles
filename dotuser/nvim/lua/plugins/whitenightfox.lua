return {
  "EdenEast/nightfox.nvim",
  config = function()
    require("nightfox").setup({
      optons = {},
      styles = {},
      palettes = {
        carbonfox = {
          fg1 = "#DEDDDA"
        },
        nightfox = {
          red     = "#CC0000",
          orange  = "#D06200",
          yellow  = "#656500",
          green   = "#008800",
          cyan    = "#688700",
          blue    = "#0200D3",
          purple  = "#6700AA",
          white   = "#7C7C7C",
          black   = "#000000",
          magenta = "#D30059",
          azure   = "#007D7D",
          pink    = "#D100D1",

          comment = "#FF0000",

          bg0     = "#DDDDDD", -- Dark bg (status line and float)
          bg1     = "#EEEEEE", -- Default bg
          bg2     = "#FFFFFF", -- Lighter bg (colorcolm folds)
          bg3     = "#FFFFFF", -- Lighter bg (cursor line)
          bg4     = "#00AAAA", -- Conceal, border fg

          fg0     = "#FFFFFF", -- Lighter fg
          fg1     = "#000000", -- Default fg
          fg2     = "#000000", -- Darker fg (status line)
          fg3     = "#000000", -- Darker fg (line numbers, fold colums)

          sel0    = "#CCCCCC", -- Popup bg, visual selection bg
          sel1    = "#FFFFFF", -- Popup sel bg, search bg
        }
      },
      specs = {
        nightfox = {
          syntax = {
            bracket     = "blue",    -- Brackets and Punctuation
            builtin0    = "red",     -- Builtin variable
            builtin1    = "pink",    -- Builtin type
            builtin2    = "cyan",    -- Builtin const
            builtin3    = "blue",    -- Not used
            comment     = "magenta", -- Comment
            conditional = "pink",    -- Conditional and loop
            const       = "cyan",    -- Constants, imports and booleans
            dep         = "red",     -- Deprecated
            field       = "black",   -- Field
            func        = "red",     -- Functions and Titles
            ident       = "red",     -- Identifiers
            keyword     = "purple",  -- Keywords
            number      = "green",   -- Numbers
            operator    = "red",     -- Operators
            preproc     = "orange",  -- PreProc
            regex       = "orange",  -- Regex
            statement   = "red",     -- Statements
            string      = "green",   -- Strings
            type        = "blue",    -- Types
            variable    = "black",   -- Variables
          }
        }
      },
      diag = {
        warn = "orange",
      }
    })

    vim.cmd("colorscheme carbonfox")
  end,
}
