-- local status, cmp = pcall(require, 'cmp')
-- if not status then
--     print "nvim cmp not available"
--     return
-- end
--
-- local function setAutoCmp(mode)
--     if mode then
--         cmp.setup({
--             completion = {
--                 autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
--             }
--         })
--     else
--         cmp.setup({
--             completion = {
--                 autocomplete = false
--             }
--         })
--     end
-- end
-- vim.api.nvim_create_autocmd("ModeChanged", {
--     group = vim.api.nvim_create_augroup("ModeChangeGroup", { clear = true }),
--     pattern = "*",  -- Apply to all buffers
--     callback = function()
--         setAutoCmp(true)
--     end,
-- })
--
-- cmp.setup({
--     snippet = {
--       -- REQUIRED - you must specify a snippet engine
--       expand = function(args)
--         -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--       end,
--     },
--     window = {
--       -- completion = cmp.config.window.bordered(),
--       documentation = cmp.config.window.bordered(),
--     },
--     mapping = cmp.mapping.preset.insert({
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ["<C-e>"] = cmp.mapping({
--             i = function()
--                 if cmp.visible() then
--                     cmp.abort()
--                     setAutoCmp(false)
--                 else
--                     setAutoCmp(true)
--                     cmp.complete()
--                 end
--             end,
--             c = function()
--                 if cmp.visible() then
--                     cmp.close()
--                     setAutoCmp(false)
--                 else
--                     setAutoCmp(true)
--                     cmp.complete()
--                 end
--             end,
--         }),
--         ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--     }),
--     sources = {
--         { name = 'nvim_lsp' },
--         --{ name = 'vsnip' }, -- For vsnip users.
--         { name = 'luasnip' }, -- For luasnip users.
--         -- { name = 'ultisnips' }, -- For ultisnips users.
--         -- { name = 'snippy' }, -- For snippy users.
--         { name = 'nvim_lsp_signature_help' },
--     }, {
--         { name = 'buffer' },
--     }
-- })
--
--   -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
-- sources = cmp.config.sources({
--   { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
-- }, {
--   { name = 'buffer' },
-- })
-- })
--
-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--       { name = 'buffer' }
--     }
-- })
-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
