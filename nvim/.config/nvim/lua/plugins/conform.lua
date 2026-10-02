return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			html = { "prettier" },
			css = { "prettier" },
		},
		format_on_save = function(bufnr)
			if not vim.g.auto_format_on_save then
				return
			end

			local filetype = vim.bo[bufnr].filetype
			if filetype ~= "html" and filetype ~= "css" then
				return
			end

			return { timeout_ms = 3000, lsp_format = "never" }
		end,
	},
}
