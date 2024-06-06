local status, tmux = pcall(require,"tmux")
if not status then return end
tmux.setup{
    navigation = {
        enable_default_keybindings = true,
    },
    resize = {
        enable_default_keybindings = false,
    }
}
