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
    theme = lualine_colorscheme,
  },
  refresh = {                  -- sets how often lualine should refreash it's contents (in ms)
    statusline = 1000,         -- The refresh option sets minimum time that lualine tries
    tabline = 1000,            -- to maintain between refresh. It's not guarantied if situation
    winbar = 1000              -- arises that lualine needs to refresh itself before this time
  },
  --winbar = {
  --    lualine_a = {'buffers'},
  --  }
})

