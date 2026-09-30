-- Started via nvim-jdtls instead of the generic lspconfig handler because
-- jdtls needs a unique per-project --data workspace dir to keep its index
-- from getting confused when you switch between Java projects.
--
-- This file runs every time a `java` FileType event fires (see nvim-jdtls's
-- "Via ftplugin" docs). Pure LSP setup for now -- no DAP/test bundles.
local jdtls = require("jdtls")

-- Tiered marker groups (same heuristic nvim-lspconfig's built-in jdtls
-- preset uses): check multi-module signals ALL the way up first, so a
-- nested module's own pom.xml/build.gradle doesn't get mistaken for the
-- project root in a multi-module Maven/Gradle reactor. Only fall back to
-- the nearest build file if none of those exist anywhere above.
local jdtls_setup = require("jdtls.setup")
local root_dir = jdtls_setup.find_root({ "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" })
	-- Fall back for single-module projects with no VCS/wrapper present
	or jdtls_setup.find_root({ "pom.xml", "build.gradle", "build.gradle.kts", "build.xml" })

-- Explicit, stable workspace dir keyed off the project name. Without this,
-- the raw jdtls binary falls back to its own OS-default cache location,
-- which is inconsistent and easy to end up duplicating.
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

jdtls.start_or_attach({
	cmd = { "jdtls", "-data", workspace_dir },
	root_dir = root_dir,
	capabilities = capabilities,
	settings = {
		java = {},
	},
	init_options = {
		bundles = {}, -- empty on purpose: no debug/test bundles yet, LSP only
	},
})
