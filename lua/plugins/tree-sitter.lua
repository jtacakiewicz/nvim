local status, configs = pcall(require, "nvim-treesitter.configs")
if not status then
    print "nvim-treesitter configs couldnt load"
    return
end
configs.setup {
    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "java", "python" },
    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true
    }

}
