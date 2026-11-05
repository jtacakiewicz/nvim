local status, gitsigns = pcall(require, ("gitsigns"))
if not status then
    print "gitsigns not available"
    return
end

gitsigns.setup {
    signcolumn = false 
}
