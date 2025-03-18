local setup, codecomp = pcall(require, 'codecompanion')
if not setup then return end
codecomp.setup({
    adapters = {
        opts = {
            show_defaults = false,
        },
        qwen = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "qwen", -- Give this adapter a different name to differentiate it from the default ollama adapter
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
        codestral = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "codestral", -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = {
                        default = "codestral",
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
        qwenmini = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "qwenmini", -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = {
                        default = "qwen2.5-coder:3b",
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
    }
})
if vim.loop.os_uname().sysname == "Darwin" then
    codecomp.setup({
        strategies = {
            chat = {
                adapter = "qwenmini",
            },
            inline = {
                adapter = "qwenmini",
            },
        }})
else
    codecomp.setup({
        strategies = {
            chat = {
                adapter = "qwen",
            },
            inline = {
                adapter = "qwen",
            },
        }})
end
