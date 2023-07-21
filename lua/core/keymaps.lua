vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>src", ":source $MYVIMRC<CR>")
keymap.set("i", "jj", "<ESC>")

keymap.set("t", "<ESC>", "<C-\\><C-n>")
keymap.set("t", "<C-]>", "<C-\\><C-n>:bnext<CR>")
keymap.set("t", "<C-[>", "<C-\\><C-n>:bprev<CR>")

keymap.set("n", "<leader>nh", ":nohl<CR>")

keymap.set("n", "x", '"_x')

keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

keymap.set({"v", "o", "n"}, "<leader>c", '"*')
keymap.set({"v", "n"}, "<leader>y", '"+y')
keymap.set({"v", "n"}, "<leader>p", '"+p')
--premage keymaps for 2 registers
keymap.set("v", "<leader>z", '"zy')
keymap.set("v", "<leader>Z", '"Zy')
keymap.set("n", "<leader>z", '"zp')
keymap.set("v", "<leader>x", '"xy')
keymap.set("v", "<leader>X", '"Xy')
keymap.set("n", "<leader>x", '"xp')
keymap.set("v", "<leader>x", '"xy')

keymap.set({"v", "o", "n"}, "<leader>e", "$")
keymap.set({"v", "o", "n"}, "<leader>w", "^")
keymap.set({"v", "o", "n"}, "<leader>a", "^")


keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("n", "<leader>so", ":only<CR>") -- close current split window
keymap.set("n", "<leader>s_", "<C-w>_") -- close current split window
keymap.set("n", "<leader>s|", "<C-w>|") -- close current split window

-- Resize with arrows
keymap.set("n", "<S-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<S-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>", opts)
keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
--keymap.set("n", "<leader>]", ":bnext<CR>") --  go to next tab
--keymap.set("n", "<leader>[", ":bprev<CR>") --  go to previous tab


-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
-- Better terminal navigation
keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

keymap.set("n", "∆",     ":m .+1<CR>==")
keymap.set("n", "Ż",     ":m .-2<CR>==")
keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")


--easy-align
--keymap.set("x", "ga", ":EasyAlign<CR>")
--keymap.set("n", "ga", ":EasyAlign<CR>")

--nvimtree
keymap.set("n", "<leader>ntt", ":NvimTreeToggle<CR>")

--telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

vim.keymap.set("n", "<leader>db", 
function() 
    --if require('nvim-tree.view').is_visible() then
    vim.api.nvim_command(":bp|bw #")
end)

keymap.set("v", "gc", function() 
    if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype") == "cpp" then
    elseif vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype") == "lua" then
    end
end)


--=====================
--nvim lsp
--=====================
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>od', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current bufferf
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    --vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>fa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>fr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>fl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>fo', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
--==========
--nvim dap
--==========
--alt as the 'debug key'

vim.keymap.set('n', '<A-c>', function() require('dap').run_to_cursor() end)
vim.keymap.set('n', '<A-CR>', function() require('dap').continue() end)
vim.keymap.set('n', '<A-down>', function() require('dap').step_over() end)
vim.keymap.set('n', '<A-right>', function() require('dap').step_into() end)
vim.keymap.set('n', '<A-left>', function() require('dap').step_out() end)
vim.keymap.set('n', 'ę', function() require('dapui').eval() end)
vim.keymap.set('n', '†', function() require('dap').terminate() end)

vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end)
--vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end)
--==========
--LuaSnip
--==========
function leave_snippet()
    if
        ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
        require('luasnip').unlink_current()
    end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_command([[
autocmd ModeChanged * lua leave_snippet()
]])

vim.cmd([[
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'jkk
]])
