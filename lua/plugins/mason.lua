local status, mason = pcall(require, "mason")
if not status then return end
mason.setup {
    keymaps = {
        ---@since 1.0.0
        -- Keymap to expand a package
        toggle_package_expand = "<CR>",
        ---@since 1.0.0
        -- Keymap to install the package under the current cursor position
        install_package = "i",
        ---@since 1.0.0
        -- Keymap to reinstall/update the package under the current cursor position
        update_package = "u",
        ---@since 1.0.0
        -- Keymap to check for new version for the package under the current cursor position
        check_package_version = "c",
        ---@since 1.0.0
        -- Keymap to update all installed packages
        update_all_packages = "U",
        ---@since 1.0.0
        -- Keymap to check which installed packages are outdated
        check_outdated_packages = "C",
        ---@since 1.0.0
        -- Keymap to uninstall a package
        uninstall_package = "X",
        ---@since 1.0.0
        -- Keymap to cancel a package installation
        cancel_installation = "<C-c>",
        ---@since 1.0.0
        -- Keymap to apply language filter
        apply_language_filter = "<C-f>",
        ---@since 1.1.0
        -- Keymap to toggle viewing package installation log
        toggle_package_install_log = "<CR>",
        ---@since 1.8.0
        -- Keymap to toggle the help view
        toggle_help = "g?",
    },
}
local status_lsp, mason_lsp = pcall(require, "mason-lspconfig")
if not status_lsp then return end
mason_lsp.setup {
    ensure_installed = { "clangd", "pylsp", "jdtls", "ts_ls" }, -- List of LSP servers to install
    automatic_installation = true,  -- Automatically install if not found
}
local status_tool, mason_tool = pcall(require, "mason-tool-installer")
if not status_tool then return end
mason_tool.setup {
    ensure_installed = { "codelldb" }, -- List of LSP servers to install
}
