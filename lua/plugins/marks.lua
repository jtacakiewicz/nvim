local setup, marks = pcall(require, "marks")
if not setup then
    print "marks unavailable"
    return
end
marks.setup {
    sign_priority = { lower=5, upper=8, builtin=4, bookmark=10 },
}
