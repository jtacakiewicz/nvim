local plugins_setup, _ = require("plugins_setup")

require("core.keymaps")
require("core.options")
require("core.colorscheme")

if plugins_setup then
require("plugins.bufferline")
require("plugins.lualine")
require("plugins.gitsigns")
require("plugins.telescope")
require("plugins.mason")

require("plugins.marks")

require("plugins.nvim-dap")
require("plugins.tree-sitter")
require("plugins.snip")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.tmux")
require("plugins.oil")
require("plugins.nvim-surround")
require("plugins.mini-align")
require("plugins.comment")
-- require("plugins.leetcode")
require("plugins.hardtime")
end
