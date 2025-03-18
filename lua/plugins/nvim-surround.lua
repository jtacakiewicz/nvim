local status, surround = pcall(require, "nvim-surround")
if not status then return end
surround.setup{
    keymaps = {
        insert = "<C-s>",
        -- insert_line = "<C-s>",
        normal = "<C-s>",
        normal_cur = "<C-s>s",
        normal_line = "<C-s>S",
        normal_cur_line = "<C-S>SS",
        visual = "<C-S>",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
    },
}
