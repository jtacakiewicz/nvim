local opt = vim.opt

opt.showmode = false
--line numbers
opt.relativenumber = true
opt.number = true

--tabs
opt.tabstop=4
opt.softtabstop=4
opt.shiftwidth=4
opt.expandtab=true
opt.autoindent=true
opt.fileformat=unix

--wrap
opt.wrap = true 
--open all folds
opt.foldlevel=99

--searching
opt.ignorecase = true
opt.smartcase = true

--cursorline
opt.cursorline = true
vim.g.neovide_cursor_trail_size = 0.1

--appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.colorcolumn = "80"

opt.backspace = "indent,eol,start"

--folds
local vim = vim
opt.foldmethod = "expr"
--opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
function _G.MyFoldText()
  return vim.fn.getline(vim.v.foldstart)
end
opt.foldtext = 'v:lua.MyFoldText()'


vim.g.filetype_pl="prolog"
local api = vim.api
local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup '..group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end


local autoCommands = {
    -- other autocommands
    open_folds = {
        {"FileReadPost", "*", "normal zR"}
    }
}

M.nvim_create_augroups(autoCommands)

-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         require('telescope.builtin').find_files()
--     end
-- })

--mouse
vim.o.mouse = "a"
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("cdpwd", { clear = true }),
    command = "cd $PWD"
})

vim.api.nvim_create_augroup("filetypedetect", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    group = "filetypedetect",
    pattern = {"*.frag", "*.vert", "*.comp"},
    command = "setfiletype glsl"
})
