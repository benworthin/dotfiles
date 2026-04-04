return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		-- Textobject keymaps for selecting/moving around code structures
		local map = vim.keymap.set
		
		-- Selection textobjects
		map({ "x", "o" }, "af", "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')<cr>", { desc = "Select outer function" })
		map({ "x", "o" }, "if", "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')<cr>", { desc = "Select inner function" })
		map({ "x", "o" }, "ac", "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')<cr>", { desc = "Select outer class" })
		map({ "x", "o" }, "ic", "<cmd>lua require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')<cr>", { desc = "Select inner class" })
		
		-- Movement between functions
		map({ "n", "x", "o" }, "]]", "<cmd>lua require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer')<cr>", { desc = "Next function start" })
		map({ "n", "x", "o" }, "][", "<cmd>lua require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer')<cr>", { desc = "Next function end" })
		map({ "n", "x", "o" }, "[[", "<cmd>lua require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer')<cr>", { desc = "Previous function start" })
		map({ "n", "x", "o" }, "[]" , "<cmd>lua require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer')<cr>", { desc = "Previous function end" })
	end,
}
