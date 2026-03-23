return {
	-- Snippet engine (required by nvim-cmp)
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
		},
	},

	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Completion sources
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"hrsh7th/cmp-buffer", -- Buffer word completions
			"hrsh7th/cmp-path", -- File path completions
			"saadparwaiz1/cmp_luasnip", -- Snippet completions
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				-- Auto-popup completion as you type
				completion = {
					autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
				},

				-- Keybindings
				mapping = cmp.mapping.preset.insert({
					-- Navigate completion menu
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll docs in completion window
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept completion
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger completion (in case you want to force it)
					["<C-Space>"] = cmp.mapping.complete(),

					-- Navigate snippets
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				-- Completion sources (order matters - higher priority first)
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP completions (will work once we add LSP)
					{ name = "luasnip" }, -- Snippet completions
					{ name = "path" }, -- File path completions
				}, {
					{ name = "buffer" }, -- Buffer word completions (fallback)
				}),

				-- Formatting (how completion items look)
				formatting = {
					format = function(entry, vim_item)
						-- Show source name
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
						})[entry.source.name]
						return vim_item
					end,
				},

				-- Add borders to completion window
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},
}
