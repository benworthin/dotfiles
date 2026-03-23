-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
  "NMAC427/guess-indent.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },

  require("plugins.colorscheme"),
  require("plugins.telescope"),
  require("plugins.neo-tree"),
  require("plugins.git"),
  require("plugins.lazygit"),
  require("plugins.toggleterm"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
  require("plugins.go"),
  require("plugins.completion"),
  require("plugins.ui"),
  require("plugins.editor"),
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
