vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>so", ":source $MYVIMRC<CR>")
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


keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>", opts)
keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
keymap.set("n", "<leader>]", ":bnext<CR>") --  go to next tab
keymap.set("n", "<leader>[", ":bprev<CR>") --  go to previous tab

-- Resize with arrows
keymap.set("n", "<S-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<S-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", opts)

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
keymap.set("x", "ga", ":EasyAlign<CR>")
keymap.set("n", "ga", ":EasyAlign<CR>")

--nvimtree
keymap.set("n", "<leader>ntt", ":NvimTreeToggle<CR>")

--telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

keymap.set("v", "gc", function() 
    if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype") == "cpp" then
        vim.api.nvim_command("s/^/(/)/")
    end
end)

--=====================
--coc
--=====================
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use tab for trigger completion with characters ahead and navigate.
-- NOTE: There's always complete item selected by default, you may want to enable
-- no select by `"suggest.noselect": true` in your configuration file.
-- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- other plugin before putting this into your config.
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keymap.set("i", "<S-TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
--keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
--keymap.set("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion.
keymap.set("i", "<C-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation.
keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window.
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


-- Highlight the symbol and its references when holding the cursor.
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming.
keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Formatting selected code.
keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

-- Setup formatexpr specified filetype(s).
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder.
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
local opts = {silent = true, nowait = true}
keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for applying codeAction to the current buffer.
keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)

-- Apply AutoFix to problem on the current line.
keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Run the Code Lens action on the current line.
keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
keymap.set("x", "if", "<Plug>(coc-funcobj-i)", opts)
keymap.set("o", "if", "<Plug>(coc-funcobj-i)", opts)
keymap.set("x", "af", "<Plug>(coc-funcobj-a)", opts)
keymap.set("o", "af", "<Plug>(coc-funcobj-a)", opts)
keymap.set("x", "ic", "<Plug>(coc-classobj-i)", opts)
keymap.set("o", "ic", "<Plug>(coc-classobj-i)", opts)
keymap.set("x", "ac", "<Plug>(coc-classobj-a)", opts)
keymap.set("o", "ac", "<Plug>(coc-classobj-a)", opts)

-- Remap <C-f> and <C-b> for scroll float windows/popups.
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keymap.set("i", "<C-f>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keymap.set("i", "<C-b>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

-- Use CTRL-S for selections ranges.
-- Requires 'textDocument/selectionRange' support of language server.
keymap.set("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
keymap.set("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
--==========
--nvim dap
--==========
vim.keymap.set('n', '<leader>dk', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end)

vim.keymap.set('n', 'ć', function() require('dap').step_over() end)
vim.keymap.set('n', '√', function() require('dap').step_into() end)
vim.keymap.set('n', 'ź', function() require('dap').step_out() end)
vim.keymap.set('n', 'ę', function() require('dapui').eval() end)

vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end)
