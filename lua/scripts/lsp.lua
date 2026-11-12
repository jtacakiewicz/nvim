local enable = function(x)
    vim.lsp.enable(x)
end
enable('clangd')
enable('vtsls')
enable('gopls')
enable('pylsp')
enable('lua_ls')

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client:supports_method('textDocument/completion') then
            local chars = {}
            for i = 32, 126 do
                table.insert(chars, string.char(i))
            end
            
            if client.server_capabilities.completionProvider then
                client.server_capabilities.completionProvider.triggerCharacters = chars
            end

            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})
