local status, leetcode = pcall(require, 'leetcode')
if not status then
    print "leetcode not available"
    return
end
leetcode.setup()
