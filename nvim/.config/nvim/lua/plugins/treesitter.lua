return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		-- Install parsers
		require('nvim-treesitter').install({
			'bash',
			'c',
			'css',
			'diff',
			'go',
			'html',
			'java',
			'javascript',
			'json',
			'lua',
			'markdown',
			'markdown_inline',
			'python',
			'query',
			'typescript',
			'vim',
			'vimdoc',
		})

		-- Enable treesitter highlighting for all filetypes (only if parser exists)
		vim.api.nvim_create_autocmd('FileType', {
			pattern = '*',
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				if vim.bo[buf].buftype == '' then
					-- Only start treesitter if a parser is available for this filetype
					pcall(vim.treesitter.start)
				end
			end,
		})
		end,
}
