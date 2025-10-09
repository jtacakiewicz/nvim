local plugins_setup, _ = require("plugins_setup")

require("core.keymaps")
require("core.options")
require("core.colorscheme")

if plugins_setup then
require("plugins.telescope")
if vim.loop.os_uname().sysname == "Darwin" then
    require("plugins.mason")
end

require("plugins.tree-sitter")
require("plugins.snip")
require("plugins.cmp")
require("plugins.tmux")
require("plugins.oil")
require("plugins.nvim-surround")

require("scripts.lsp")
require("scripts.bufferline")
require("scripts.lualine")
end
