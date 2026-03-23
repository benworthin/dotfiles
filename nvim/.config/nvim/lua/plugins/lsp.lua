return {
	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason: Portable package manager for LSP servers, DAP servers, linters, formatters
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- Auto-format on save (can be toggled with <leader>tf)
			vim.g.auto_format_on_save = true

			-- This function runs when an LSP attaches to a buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					-- Helper function to set keymaps
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to definition
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to implementation
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to type definition
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find symbols in document
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find symbols in workspace
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename variable
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Code action
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Show hover documentation
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Jump to declaration (not all servers support this)
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Highlight references of word under cursor when idle
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Toggle inlay hints (if supported)
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end

					-- Toggle auto-format on save
					map("<leader>tf", function()
						vim.g.auto_format_on_save = not vim.g.auto_format_on_save
						local status = vim.g.auto_format_on_save and "enabled" or "disabled"
						vim.notify("Auto-format on save " .. status, vim.log.levels.INFO)
					end, "[T]oggle Auto-[F]ormat")
				end,
			})

			-- Auto-format on save
			-- Note: Go files are handled by go.nvim (see plugins/go.lua)
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("lsp-format-on-save", { clear = true }),
				callback = function(event)
					-- Check if auto-format is enabled
					if not vim.g.auto_format_on_save then
						return
					end

					-- Skip Go files (handled by go.nvim)
					if vim.bo[event.buf].filetype == "go" then
						return
					end

					-- Format using LSP if available
					local clients = vim.lsp.get_clients({ bufnr = event.buf })
					if #clients > 0 then
						vim.lsp.buf.format({
							bufnr = event.buf,
							timeout_ms = 3000,
							-- You can filter which servers to use for formatting here
							filter = function(client)
								-- Example: Only use specific formatters
								-- For now, use any server that supports formatting
								return client.server_capabilities.documentFormattingProvider
							end,
						})
					end
				end,
			})

			-- LSP servers and clients can communicate what features they support
			-- By default, Neovim doesn't support everything that is in the LSP spec
			-- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities
			-- We broadcast that to the servers so they know what we can do
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable nice borders on LSP windows
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Customize diagnostic display
			vim.diagnostic.config({
				virtual_text = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Setup Mason (package manager for LSP servers)
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Define the language servers we want to install
			local servers = {
				-- Go (gopls) - go.nvim provides extra Go tools on top of this
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},

				-- Python
				pyright = {},

				-- SQL
				sqls = {},

				-- JSON
				jsonls = {},

				-- Java
				jdtls = {},

				-- JavaScript/TypeScript
				ts_ls = {},

				-- HTML
				html = {},

				-- CSS
				cssls = {},

				-- Lua (for your Neovim config - neodev already configured this)
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools are installed
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Language servers
					"gopls",
					"pyright",
					"sqls",
					"jsonls",
					"jdtls",
					"ts_ls",
					"html",
					"cssls",
					"lua_ls",
				},
			})

			-- Setup mason-lspconfig (bridge between mason and lspconfig)
			require("mason-lspconfig").setup({
				handlers = {
					-- Default handler for all servers
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful for disabling
						-- certain features of an LSP (e.g., turning off formatting)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
