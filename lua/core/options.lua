local opt = vim.opt

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
opt.wrap = false
--open all folds
opt.foldlevel=99

--searching
opt.ignorecase = true
opt.smartcase = true

--cursorline
opt.cursorline = true

--appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

--folds
local vim = vim
local opt = vim.opt
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"


vim.g.filetype_pl="prolog"
local vim = vim
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
        {"BufReadPost,FileReadPost", "*", "normal zR"}
    }
}

M.nvim_create_augroups(autoCommands)

--clipboard
--opt.clipboard:append("unnamedplus")

--mouse
local status, _ = pcall(vim.cmd, [[
set mouse=a
augroup cdpwd
    autocmd!
    autocmd BufWinEnter * cd $PWD
augroup END
]])
if not status then
    print("couldnt call vim function")
    return
end
