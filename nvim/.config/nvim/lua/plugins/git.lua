return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "[G]it [B]lame toggle" },
			{ "<leader>gB", "<cmd>Gitsigns blame_line<CR>", desc = "[G]it [B]lame line detail" },
			{ "<leader>gbb", "<cmd>Gitsigns blame<CR>", desc = "[G]it [B]lame buffer" },
		},
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
			"DiffviewFileHistory",
		},
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "[G]it [D]iff view (all changes)" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "[G]it file [H]istory" },
			{ "<leader>gp", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "[G]it [P]R diff (vs main)" },
		},
		opts = {
			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_horizontal",
					disable_diagnostics = true,
				},
				file_history = {
					layout = "diff2_horizontal",
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
				win_config = {
					position = "left",
					height = 10,
					width = 35,
				},
			},
			file_history_panel = {
				log_options = {
					git = {
						single_file = {
							max_count = 256,
							follow = false,
							all = false,
						},
						multi_file = {
							max_count = 0,
						},
					},
				},
				win_config = {
					position = "bottom",
					height = 16,
				},
			},
			default_args = {
				DiffviewOpen = {},
				DiffviewFileHistory = {},
			},
			hooks = {
				diff_buf_read = function()
					vim.opt_local.wrap = false
					vim.opt_local.list = false
				end,
			},
		},
		config = function(_, opts)
			require("diffview").setup(opts)

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { noremap = true, silent = true, desc = desc })
			end

			map("n", "<leader>gx", "<cmd>DiffviewClose<CR>", "Close [G]it diff view")
			map("n", "<leader>ge", "<cmd>DiffviewToggleFiles<CR>", "Toggle diff file panel")
			map("n", "<leader>gj", "<cmd>normal! ]c<CR>", "[G]it [J]ump down to next change")
			map("n", "<leader>gk", "<cmd>normal! [c<CR>", "[G]it [J]ump up to previous change")
		end,
	},
}

