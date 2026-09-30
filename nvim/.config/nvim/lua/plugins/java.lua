return {
	-- Extends built-in LSP support for eclipse.jdt.ls (jdtls) with proper
	-- per-project workspace handling. Actual startup logic lives in
	-- ftplugin/java.lua since jdtls can't be managed like a stateless
	-- server through the generic mason-lspconfig handler.
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
	},
}
