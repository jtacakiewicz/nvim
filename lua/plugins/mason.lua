local status, mason = pcall(require, "mason")
if not status then return end
mason.setup()
local status_lsp, mason_lsp = pcall(require, "mason")
if not status_lsp then return end
mason_lsp.setup()
