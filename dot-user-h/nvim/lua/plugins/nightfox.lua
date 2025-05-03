return {
    "EdenEast/nightfox.nvim",
    config = function()
        require("nightfox").setup ({
            optons = {},
            styles = {},
            palettes = {
                carbonfox = {
                    fg1 = "#DEDDDA"
                },
                nightfox = {
                    black       = "#000000",
                    black_li    = "#141414",
                    red         = "#E26D6D", 
                    red_li      = "#E09999",
                    green       = "#6DD57C",
                    green_li    = "#94D59D",
                    yellow      = "#D5DA6E",
                    yellow_li   = "#D6D998",
                    blue        = "#74C1D9",
                    blue_li     = "#8FD1DB", 
                    magenta     = "#E06EBA", 
                    magenta_li  = "#DCA1C8",
                    cyan        = "#A7D778",
                    cyan_li     = "#C5DFA0",
                    white       = "#E0E0E0",
                    white_de    = "#D8C7D0",
                    orange      = "#DAAA6D",
                    orange_li   = "#D9BC96",
                    pink        = "#D372DA",
                    pink_li     = "#D7A2DB",
                    pink_de     = "#DD36E0",

                    comment     = "#DBDAD6",

                    bg0         = "#1C1C1C", -- Dark bg (status line and float)
                    bg1         = "#090909", -- Default bg
                    bg2         = "#252525", -- Lighter bg (colorcolm folds)
                    bg3         = "#202020", -- Lighter bg (cursor line)
                    bg4         = "#FFF000", -- Conceal, border fg

                    fg0         = "#000000", -- Lighter fg
                    fg1         = "#C0BFBC", -- Default fg
                    fg2         = "#C0BFBC", -- Darker fg (status line)
                    fg3         = "#C0BFBC", -- Darker fg (line numbers, fold colums)

                    sel0        = "#252525", -- Popup bg, visual selection bg
                    sel1        = "#3c5372", -- Popup sel bg, search bg
                }
            },
            specs = {
                nightfox = {
                    syntax = {
                        bracket     = "orange",     -- Brackets and Punctuation
                        builtin0    = "white_de",   -- Builtin variable
                        builtin1    = "pink_li",    -- Builtin type
                        builtin2    = "green",      -- Builtin const
                        builtin3    = "red",        -- Not used
                        comment     = "pink_li",    -- Comment
                        conditional = "pink",       -- Conditional and loop
                        const       = "green",      -- Constants, imports and booleans
                        dep         = "yellow",     -- Deprecated
                        field       = "orange",     -- Field
                        func        = "pink_de",    -- Functions and Titles
                        ident       = "yellow",     -- Identifiers
                        keyword     = "pink",       -- Keywords
                        number      = "yellow",     -- Numbers
                        operator    = "red",        -- Operators
                        preproc     = "pink",       -- PreProc
                        regex       = "pink_li",    -- Regex
                        statement   = "red",        -- Statements
                        string      = "cyan",       -- Strings
                        type        = "blue",       -- Types
                        variable    = "white_de",   -- Variables
                    }
                }
            }
        })

        vim.cmd("colorscheme nightfox")
    end,
}
