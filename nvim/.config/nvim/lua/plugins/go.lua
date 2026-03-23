return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua", -- UI library for go.nvim
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- Install/update all Go tools
	config = function()
		require("go").setup({
			-- Disable go.nvim's LSP config (we handle it in lsp.lua)
			lsp_cfg = false,
			lsp_keymaps = false, -- We already set up LSP keymaps in lsp.lua
			textobjects = false, -- Use nvim-treesitter-textobjects plugin instead

			-- LSP settings (gopls)
			lsp_inlay_hints = {
				enable = true,
				-- Only show inlay hints for the current line
				only_current_line = false,
			},

			-- Diagnostic settings
			diagnostic = {
				underline = true,
				virtual_text = { spacing = 4, prefix = "■" },
				signs = true,
				update_in_insert = false,
			},

			-- Code linting
			linter_flags = "-fast",

			-- Test settings
			run_in_floaterm = false, -- Run tests in buffer, not floating terminal
			test_runner = "go", -- Use 'go test' (can also be 'richgo', 'ginkgo')

			-- Auto-format on save
			-- We'll handle this in Step 6 for all languages
			-- but go.nvim has its own formatter integration

			-- Icons
			icons = { breakpoint = "🔴", currentpos = "🔶" },

			-- Verbose output for debugging (set to false normally)
			verbose = false,
		})

		-- Go-specific keymaps
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { desc = "Go: " .. desc, silent = true })
		end

		-- Format and organize imports
		map("n", "<leader>gf", "<cmd>GoFmt<cr>", "[F]ormat")
		map("n", "<leader>gi", "<cmd>GoImport<cr>", "Organize [I]mports")

		-- Test commands
		map("n", "<leader>gt", "<cmd>GoTest<cr>", "Run [T]ests")
		map("n", "<leader>gT", "<cmd>GoTestFunc<cr>", "Run [T]est Function")
		map("n", "<leader>gc", "<cmd>GoCoverage<cr>", "Show [C]overage")

		-- Code generation
		map("n", "<leader>ge", "<cmd>GoIfErr<cr>", "Generate if [e]rr")
		map("n", "<leader>gs", "<cmd>GoFillStruct<cr>", "Fill [S]truct")
		map("n", "<leader>gI", "<cmd>GoImpl<cr>", "[I]mplement Interface")

		-- Struct tags
		map("n", "<leader>ga", "<cmd>GoAddTag<cr>", "[A]dd Tags")
		map("n", "<leader>gr", "<cmd>GoRmTag<cr>", "[R]emove Tags")

		-- Module commands
		map("n", "<leader>gm", "<cmd>GoModTidy<cr>", "Go [M]od Tidy")

		-- Auto-format on save for Go files
		local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimport()
			end,
			group = format_sync_grp,
		})
	end,
}
