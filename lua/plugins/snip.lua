local status, sniploaders = pcall(require, ("luasnip.loaders.from_vscode"))
if not status then
    print "luasnip not available"
    return
end
local snipstatus, snip = pcall(require, ("luasnip"))
if not snipstatus then
    print "luasnip not available"
    return
end
snip.filetype_extend("cpp", {"cpp"})
sniploaders.lazy_load()

