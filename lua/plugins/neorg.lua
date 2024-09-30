local status, neorg = pcall(require, 'neorg')
if not status then
    print 'neor setup failed'
    return
end
neorg.setup {}
