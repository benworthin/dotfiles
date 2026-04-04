-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit insert mode with jk
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, desc = "Exit insert mode" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation with CTRL+hjkl
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize windows with Option + Arrow keys
vim.keymap.set("n", "<M-Up>", ":resize +5<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<M-Down>", ":resize -5<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<M-Left>", ":vertical resize -5<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<M-Right>", ":vertical resize +5<CR>", { desc = "Increase window width" })

-- Tab navigation
vim.keymap.set("n", "<leader>tk", "<cmd>tabnext<CR>", { desc = "[T]ab [K]next (right)" })
vim.keymap.set("n", "<leader>tj", "<cmd>tabprevious<CR>", { desc = "[T]ab [J]previous (left)" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "[T]ab [C]lose" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "[T]ab [N]ew" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "[T]ab [O]nly (close all others)" })

-- Fold function under cursor
vim.keymap.set("n", "<leader>zf", "vafzf", { noremap = true, silent = true, desc = "Fold function" })
