local keyset = vim.keymap.set

-- 插入模式
keyset("i", "jk", "<ESC>")

-- 视觉模式
-- 单行或多行移动
keyset("v", "<down>", ":m '>+1<CR>gv=gv")
keyset("v", "<up>", ":m '<-2<CR>gv=gv")

-- 普通模式
keyset("n", "<leader>c", ":w<CR> :term gcc % -o exe && ./exe<CR>")
keyset("n", "<leader>g", ":w<CR> :term python3 %<CR>")
keyset("n", "<leader>e", ":NvimTreeToggle<CR>")
keyset("n", "<leader>w", ":w<CR>")
keyset("n", "<leader>s", ":x<CR>")
keyset("n", "<leader>q", ":q!<CR>")
keyset("n", "<A-l>", ":BufferLineCycleNext<CR>")
keyset("n", "<A-h>", ":BufferLineCyclePrev<CR>")
keyset("n", "<leader>bd", ":bdelete<CR>")




