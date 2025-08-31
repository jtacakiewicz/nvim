vim.opt.termguicolors = true

-- Function to safely get highlight colors
local function get_hl_colors(group)
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
    if not ok then return { fg=nil, bg=nil } end
    local function hex(n) return n and string.format("#%06x", n) or nil end
    return { fg = hex(hl.foreground), bg = hex(hl.background) }
end

-- Define statusline highlight groups
local hl_groups = {
    SLMode     = get_hl_colors("ModeMsg"),
    SLBranch   = get_hl_colors("GitGraphBranch2"),
    SLFile     = get_hl_colors("BufferCurrent"),
    SLMod      = get_hl_colors("BufferCurrentMod"),
    SLPosition = get_hl_colors("Number"),
}

for name, col in pairs(hl_groups) do
    vim.api.nvim_set_hl(0, name, { fg = col.fg, bg = col.bg, bold = name=="SLMode" })
end

-- Current mode
local function get_mode()
    local mode_map = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        [""] = "V-BLOCK",
        c = "COMMAND",
        R = "REPLACE",
        t = "TERMINAL"
    }
    return mode_map[vim.api.nvim_get_mode().mode] or "UNKNOWN"
end

-- Git branch
local function get_git_branch()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    if branch == "" then return "" end
    return " " .. branch
end

-- File info
local function get_file_info()
    local file_name = vim.fn.expand("%:t")
    if file_name == "" then file_name = "[No Name]" end
    local filetype = vim.bo.filetype
    return file_name .. " [" .. filetype .. "]"
end

-- Line/column
local function get_position()
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    local total = vim.fn.line("$")
    return string.format("%d:%d [%d%%]", line, col, math.floor(line/total*100))
end
-- Broken for now
local function get_git_changes()
    local file = vim.fn.expand("%:p")
    if vim.fn.filereadable(file) == 0 then return "" end

    -- Run git diff --numstat for the current file
    local git_cmd = string.format("git diff --numstat 2>/dev/null | grep %s", file)
    local output = vim.fn.systemlist(git_cmd)
    if #output == 0 then return git_cmd end

    local added, removed = 0, 0
    for _, line in ipairs(output) do
        -- numstat format: <added> <removed> <file>
        local a, r = line:match("^(%d+)%s+(%d+)")
        if a and r then
            added = added + tonumber(a)
            removed = removed + tonumber(r)
        end
    end

    local changes = {}
    if added > 0 then table.insert(changes, "+ " .. added) end
    if removed > 0 then table.insert(changes, "- " .. removed) end

    return git_cmd
end

local function get_file_percent()
    local line = vim.fn.line(".")          -- current line
    local total = vim.fn.line("$")         -- total lines
    if total == 0 then return "0%" end
    return string.format("%d%%", math.floor(line / total * 100)) .. "%"
end


-- Build statusline with colors
local function statusline()
    return table.concat({
        "%#SLMode#" .. get_mode(),
        "%#SLBranch#" .. get_git_branch(),
        "%#SLFile#" .. get_file_info(),
        "%#SLPosition#" .. get_file_percent(),
    }, " %#SLMode#| ")
end

-- Expose function globally
_G.StatusLine = statusline
-- Apply the status line
vim.o.statusline = "%!v:lua.StatusLine()"
