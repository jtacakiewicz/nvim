local snipstatus, luasnip = pcall(require, 'luasnip')
if not snipstatus then
    print "luasnip not available"
    return
end

local cmpstatus, cmp = pcall(require, 'cmp')
if not cmpstatus then
    print "nvim cmp not available"
    return
end
local function setAutoCmp(mode)
    if mode then
        cmp.setup({
            completion = {
                autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
            }
        })
    else
        cmp.setup({
            completion = {
                autocomplete = false
            }
        })
    end
end
vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("ModeChangeGroup", { clear = true }),
    pattern = "*",  -- Apply to all buffers
    callback = function()
        setAutoCmp(true)
    end,
})
--nvim-cmp setup
cmp.setup {
    enabled = function()
        -- disable completion in comments
        local context = require('cmp.config.context')
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
        end
    end,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    performance = {
        -- max_view_entries = 5,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping({
            i = function()
                if cmp.visible() then
                    cmp.abort()
                    setAutoCmp(false)
                else
                    setAutoCmp(true)
                    cmp.complete()
                end
            end,
            c = function()
                if cmp.visible() then
                    cmp.close()
                    setAutoCmp(false)
                else
                    setAutoCmp(true)
                    cmp.complete()
                end
            end,
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-f>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local enter_key = vim.api.nvim_replace_termcodes("<CR>", true, false, true)

                -- Feed the Enter key
                vim.api.nvim_feedkeys(enter_key, "i", false)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'codecompanion' },
    }, {
        { name = 'buffer' }
    }),
}
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--       { name = 'buffer' }
--     }
-- })
