local setup, codecomp = pcall(require, 'codecompanion')
    print('Hello World')
if not setup then return end
require("codecompanion").setup({
    adapters = {
        opts = {
            show_defaults = false,
        },
        codestral = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "codestral", -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = {
                        default = "qwen2.5-coder:14b",
                    },
                    num_ctx = {
                        default = 1024,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
            })
        end,
    },
    strategies = {
        chat = {
            adapter = "codestral",
        },
        inline = {
            adapter = "codestral",
        },
    },
})
