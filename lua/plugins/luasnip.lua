local status, snip = pcall(require, ("luasnip.loaders.from_vscode"))
if not status then
    print "luasnip not available"
    return
end
snip.lazy_load()
