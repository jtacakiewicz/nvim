local setup, telescope = pcall(require, "telescope")
if not setup then
    print "telescope unavailable"
    return
end

telescope.load_extension("undo")
telescope.load_extension("fzf")
-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
    return
end

-- configure telescope
telescope.setup({
    -- configure custom mappings
    defaults = {
        ripgrep_arguments = {
            'rg',
            '--hidden',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                ["<C-l>"] = actions.send_selected_to_loclist, -- move to next result
                ["<C-j>"] = actions.move_selection_next, -- move to next result
                ["<C-q>"] = function(prompt_bufnr)
                    local qflist = vim.fn.getqflist()
                    if vim.tbl_isempty(qflist) then
                        -- Add all entries to quickfix list
                        actions.send_to_qflist(prompt_bufnr)
                    else
                        -- Add only selected entries to quickfix list
                        actions.send_selected_to_qflist(prompt_bufnr)
                    end
                    actions.open_qflist()
                end,
            },
        },
    },
})


