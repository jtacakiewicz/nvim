-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end

-- get lualine nightfly theme
local lualine_colorscheme = require("lualine.themes.nord")

-- change nightlfy theme colors
--lualine_nightfly.normal.a.bg = new_colors.blue
--lualine_nightfly.insert.a.bg = new_colors.green
--lualine_nightfly.visual.a.bg = new_colors.violet
lualine_colorscheme.command = {
  a = {
    gui = "bold",
  },
}

-- configure lualine with modified theme
lualine.setup({
    options = {
        icons_enabled = true,
        theme = lualine_colorscheme,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' --[[ , 'diagnostics' ]] },
        lualine_c = { --[[ 'filename' ]] },
        lualine_x = { --[[ 'encoding', 'fileformat', 'filetype' ]] },
        lualine_y = { --[[ 'progress' ]] },
        lualine_z = { --[[ 'location' ]] }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { --[[ 'filename' ]] },
        lualine_x = { --[[ 'location' ]] },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})
require('lualine').setup {
}

