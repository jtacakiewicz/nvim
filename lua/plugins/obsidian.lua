local setup, obsidian = pcall(require, "obsidian")
if not setup then
    print "obsidian unavailable"
    return
end
obsidian.setup {
    ft = "markdown",
    workspaces = {
        {
            name = "personal",
            path = "~/Documents/notes/Epicurus",
        },
    },
    note_id_func = function(title)
        if title ~= nil then
            -- Convert title to lowercase and replace spaces with hyphens, e.g. "My Note" -> "my-note"
            return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
            return "untitled"
        end
    end,
}
