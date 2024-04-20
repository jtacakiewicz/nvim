vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>src", function() vim.cmd("luafile %") end, { desc = "sourcing neovim setup" })

-- keymap.set("t", "<ESC>", "<C-\\><C-n>")
-- keymap.set("t", "<C-]>", "<C-\\><C-n>:bnext<CR>")
-- keymap.set("t", "<C-[>", "<C-\\><C-n>:bprev<CR>")

keymap.set("n", "<leader>nh", function() vim.cmd("nohl") end, { desc = "hide active highlights"} )

keymap.set({"v", "o", "n"}, "x", '"_x', { desc = "x no longer adds to registers" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "add one to numeric value" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "sub one to numeric value" })

keymap.set({"v", "o", "n"}, "<leader>c", '"*', { desc = "access clipboard register" })
keymap.set({"v", "n"}, "<leader>y", '"+y', { desc = "yank to clipboard" })
keymap.set({"v", "n"}, "<leader>p", '"+p', { desc = "paste from clipboard" })
--premage keymaps for 2 registers
keymap.set("v", "<leader>z", '"zy', { desc = "yank into z register" })
keymap.set("v", "<leader>Z", '"Zy', { desc = "yank into Z register" })
keymap.set("n", "<leader>z", '"zp', { desc = "paste from z register" })
keymap.set("v", "<leader>x", '"xy', { desc = "yank into x register" })
keymap.set("v", "<leader>X", '"Xy', { desc = "yank into X register" })
keymap.set("n", "<leader>x", '"xp', { desc = "paste from x register" })

-- keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
-- keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
-- keymap.set("n", "<leader>se", "<C-w>=", { desc = "make split windows equal width & height" })
-- keymap.set("n", "<leader>sx", "<C-w>c", { desc = "close current split window" })
-- keymap.set("n", "<leader>so", "<C-w>o", { desc = "close current split window" })
-- keymap.set("n", "<leader>s_", "<C-w>_", { desc = "max the height of split" })
-- keymap.set("n", "<leader>s|", "<C-w>|", { desc = "max the width of split" })

-- Resize with arrows
keymap.set("n", "<S-Up>",    function() require("tmux").resize_top() end,    { desc = "resize split windows/split tmux windows" })
keymap.set("n", "<S-Down>",  function() require("tmux").resize_bottom() end, { desc = "resize split windows/split tmux windows" })
keymap.set("n", "<S-Left>",  function() require("tmux").resize_left() end,   { desc = "resize split windows/split tmux windows" })
keymap.set("n", "<S-Right>", function() require("tmux").resize_right() end,  { desc = "resize split windows/split tmux windows" })

keymap.set("n", "<leader>oo", function() require("oil").open(require("oil").get_current_dir()) end, { desc = "opens oil.nvim"} )

-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>", {desc = "switch to next buffer"} )
keymap.set("n", "<S-h>", ":bprevious<CR>", {desc = "switch to prev buffer"} )
--keymap.set("n", "<leader>]", ":bnext<CR>") --  go to next tab
--keymap.set("n", "<leader>[", ":bprev<CR>") --  go to previous tab


-- Stay in indent mode
keymap.set("v", "<", "<gv", {desc = "shift text left"} )
keymap.set("v", ">", ">gv", {desc = "shift text right"} )
-- Better terminal navigation

--move lines
keymap.set("n", "<A-j>", ":m .+1<CR>==",        {desc = "move line down"} )
keymap.set("n", "<A-k>", ":m .-2<CR>==",        {desc = "move line up"} )
keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", {desc = "move line down"} )
keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", {desc = "move line up"} )
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",    {desc = "move line down"} )
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",    {desc = "move line up"} )


--easy-align
--keymap.set("x", "ga", ":EasyAlign<CR>")
--keymap.set("n", "ga", ":EasyAlign<CR>")

--nvimtree
keymap.set("n", "<leader>ntt", function() vim.cmd("NvimTreeToggle") end, {desc = "toggle nvim-tree" })

--telescope
keymap.set("n", "<leader>ff", function() vim.cmd("Telescope find_files") end) -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", function() vim.cmd("Telescope live_grep") end) -- find string in current working directory as you type
keymap.set("n", "<leader>fc", function() vim.cmd("Telescope grep_string") end) -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", function() vim.cmd("Telescope buffers") end) -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", function() vim.cmd("Telescope help_tags") end) -- list available help tags

vim.keymap.set("n", "_", function()  vim.cmd("bp|bd #") end, {desc = "delete buffer and switch to prev"} )


--=====================
--nvim lsp
--=====================
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>od', vim.diagnostic.open_float, {desc = "opens diagnostic floating window" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = "goes to prev diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = "goest to next diagnostic" })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, {desc = "lists diagnosic locations" })
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current bufferf
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    --vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,             { buffer = ev.buf, desc = "goto declaration" })
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,              { buffer = ev.buf, desc = "goto definition" })
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,                   { buffer = ev.buf, desc = "hover" })
    vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation,          { buffer = ev.buf, desc = "implementation" })
    vim.keymap.set('n', '<C-s>',      vim.lsp.buf.signature_help,          { buffer = ev.buf, desc = "signature_help" })
    vim.keymap.set('n', '<leader>fa', vim.lsp.buf.add_workspace_folder,    { buffer = ev.buf, desc = "add_workspace_folder" })
    vim.keymap.set('n', '<leader>fr', vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "remove_workspace_folder" })
    vim.keymap.set('n', '<leader>fl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = ev.buf, desc = "lists workspace folders" })
    vim.keymap.set('n', '<leader>D',  vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "goto type definition" })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,          { buffer = ev.buf, desc = "rename" })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,     { buffer = ev.buf, desc = "code action" })
    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,      { buffer = ev.buf, desc = "goto references" })
    vim.keymap.set('n', '<leader>fo', function()
        vim.lsp.buf.format { async = true }
    end, { buffer = ev.buf, desc = "format current buffer" })
    local range_formatting = function()
        local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
        local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
        vim.lsp.buf.format({
            range = {
                ["start"] = { start_row, 0 },
                ["end"] = { end_row, 0 },
            },
            async = true,
        })
    end

    vim.keymap.set("v", "<leader>fo", range_formatting, { buffer = ev.buf, desc = "format selected range" })
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
--either show diagnostic message or eval expression if debug session is active
vim.keymap.set('n', '<A-e>', function()
        if require('dap').status() == "" then
            vim.diagnostic.open_float(nil, opts)
        else
            require('dapui').eval()
        end
    end)
vim.keymap.set('n', '<A-t>', function() require('dap').terminate() end)

vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, {desc = "sets a breakpoint" })
--vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, {desc = "sets a logging breakpint"})

vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, {desc = "toggle dapui gui"})
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

local status, _ = require("luasnip")
if(status) then
    vim.keymap.set({"i", "s"}, "<Tab>", function()
        if(require("luasnip").expand_or_jumpable()) then
            require("luasnip").expand_or_jump()
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
    end, {silent = true})
    vim.keymap.set({"i", "s"}, "<S-Tab>", function() require("luasnip").jump(-1) end, {silent = true})

    vim.keymap.set({"i", "s"}, "<C-E>", function()
        if require("luasnip").choice_active() then
            require("luasnip").change_choice(1)
        end
    end, {silent = true})
end
