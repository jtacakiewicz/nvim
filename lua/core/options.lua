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

--clipboard
--opt.clipboard:append("unnamedplus")

--mouse
local status, _ = pcall(vim.cmd, [[
set foldmethod=indent
set foldlevel=99
"save and open folds
augroup remember_folds
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END
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
