local opt = vim.opt

opt.laststatus=0
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

--appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
local long_line_match = nil

vim.api.nvim_create_user_command("Yesendl", function()
  if not long_line_match then
    long_line_match = vim.fn.matchadd("ErrorMsg", [[\%>100v.\+]])
  end
end, {})

vim.api.nvim_create_user_command("Noendl", function()
  if long_line_match then
    vim.fn.matchdelete(long_line_match)
    long_line_match = nil
  end
end, {})

opt.backspace = "indent,eol,start"

--folds
opt.foldmethod = "expr"
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
function _G.MyFoldText()
  return vim.fn.getline(vim.v.foldstart)
end
opt.foldtext = 'v:lua.MyFoldText()'

vim.g.filetype_pl="prolog"

local autoCommands = {
    -- other autocommands
    open_folds = {
        {"FileReadPost", "*", "normal zR"}
    },
    cdpwd = {
        {"BufWinEnter", "*", "cd $PWD"}
    },
    filetypedetect = {
        {"BufNewFile,BufRead", "*.frag,*.vert,*.comp", "setfiletype glsl"}
    },
    telescope_on_start = {
        {"VimEnter", "*", 'lua if vim.fn.argv(0) == "" then require("telescope.builtin").find_files() end'}
    }
}
require("../scripts/autogroups").setup(autoCommands)
--mouse
vim.o.mouse = "a"
