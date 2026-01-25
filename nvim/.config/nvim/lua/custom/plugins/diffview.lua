-- Interactive diff viewer - gives you that IntelliJ/GoLand diff experience
-- Provides a split-pane view with file tree, side-by-side diffs, and interactive hunk staging
--
-- Key Commands:
--   :DiffviewOpen          - Open diff view for current changes
--   :DiffviewOpen HEAD~1   - Compare with specific revision
--   :DiffviewFileHistory   - View file history
--
-- In diff view:
--   ]c / [c                - Next/Previous change
--   <leader>e              - Focus file panel
--   <leader>o              - Open file
--   <leader>ca             - Choose all from one side (in merge conflicts)
--   <leader>cb / <leader>cc / <leader>co - Choose base/ours/theirs in conflicts

return {
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
    },
    opts = {
      -- Configuration options
      view = {
        -- Split the diff view - left for files, right for the actual diff
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
        listing_style = "tree", -- "list" | "tree"
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        width = 35,
        height = 10,
        position = "left",
        win_config = {
          position = "topleft",
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
          -- Optional: set up diff buffer options
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    },
    config = function(_, opts)
      require("diffview").setup(opts)

      -- Additional keymaps in diff view
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { noremap = true, silent = true, desc = desc })
      end

      -- Close diffview and return to normal editing
      map("n", "<leader>gx", "<cmd>DiffviewClose<CR>", "Close [G]it diff view")

      -- Toggle the file panel
      map("n", "<leader>ge", "<cmd>DiffviewToggleFiles<CR>", "Toggle diff file panel")

      -- Navigate changes in diffview
      map("n", "<leader>gj", "<cmd>normal! ]c<CR>", "[G]it [J]ump down to next change")
      map("n", "<leader>gk", "<cmd>normal! [c<CR>", "[G]it [J]ump up to previous change")
    end,
  },
}
