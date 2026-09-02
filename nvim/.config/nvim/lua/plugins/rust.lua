return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- pin to latest major version, per plugin's own recommendation
	lazy = false, -- rustaceanvim manages its own lazy-loading via `ft`
	ft = { "rust" },
	config = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
					end

					-- Rustaceanvim-specific commands (generic LSP keymaps already come from lsp.lua)
					map("<leader>Ra", function() vim.cmd.RustLsp("codeAction") end, "Code [A]ction")
					map("<leader>Rr", function() vim.cmd.RustLsp("runnables") end, "[R]unnables")
					map("<leader>Rt", function() vim.cmd.RustLsp("testables") end, "[T]estables")
					map("<leader>Rd", function() vim.cmd.RustLsp("debuggables") end, "[D]ebuggables")
					map("<leader>RK", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover Actions")
					map("<leader>Rm", function() vim.cmd.RustLsp("expandMacro") end, "Expand [M]acro")
					map("<leader>Rp", function() vim.cmd.RustLsp("parentModule") end, "[P]arent Module")
					map("<leader>Rc", function() vim.cmd.RustLsp("openCargo") end, "Open [C]argo.toml")
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						checkOnSave = true, -- boolean toggle (newer rust-analyzer schema)
						check = { command = "clippy" }, -- lint w/ clippy, same spirit as your gopls staticcheck
						inlayHints = {
							bindingModeHints = { enable = false },
							closureReturnTypeHints = { enable = "always" },
						},
					},
				},
			},
		}
	end,
}
