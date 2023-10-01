vault_dir=os.getenv( "HOME" ).."/PersonalVault"
excalidraw_dir=os.getenv( "HOME" ).."/PersonalVault/Excalidraw"

require("obsidian").setup({
    dir = vault_dir,
    -- see below for full list of options 👇
})
--if inside vault
if vim.fn.getcwd() == vault_dir then
    vim.g.instant_markdown_autostart = 0
    vim.api.nvim_create_autocmd({"BufWinEnter", "BufReadPost", "FileReadPost"}, {
      pattern = {"*.md"},
      callback = function(ev)
        vim.api.nvim_command("ObsidianOpen")
      end
    })

    vim.keymap.set('n', '<A-CR>', 
        function() 
            vim.api.nvim_command("ObsidianFollowLink") 
        end
    )
    --alt + d
    vim.keymap.set('n', '∂', 
        function() 
            print("hi")
            local fname = vim.fn.input("Name of the excalidraw file: ", "", "file")
            vim.cmd("e " .. excalidraw_dir .. "/" .. fname .. ".excalidraw.md")
            vim.api.nvim_buf_set_lines(0, 0, 0, false, {
                [[---]],
                [[id: "]] .. fname .. [[.excalidraw"]],
                [[aliases:]],
                [[  - "Drawing"]],
                [[tags:]],
                [[  - "excalidraw"]],
                [[excalidraw-plugin: "parsed"]],
                [[---]],
                [[==⚠  Switch to EXCALIDRAW VIEW in the MORE OPTIONS menu of this document. ⚠==]],
                [[%%]],
                [[# Drawing]],
                [[```json]],
                [[{"type":"excalidraw","version":2,"source":"https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/tag/1.9.7","elements":[],"appState":{"gridSize":null,"viewBackgroundColor":"#ffffff"}} ]],
                [[```]],
                [[%%]]
            })
        end
    )
end
