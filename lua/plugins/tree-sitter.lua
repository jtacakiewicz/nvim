local configs = require("nvim-treesitter.configs")
configs.setup {
    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "java", "python" },
    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true
    }

}
