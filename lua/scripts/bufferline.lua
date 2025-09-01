-- Simple bufferline without plugins
local deviconssetup, devicons = pcall(require, 'nvim-web-devicons')
local function bufferline()
    local buffers = vim.api.nvim_list_bufs()
    local current = vim.api.nvim_get_current_buf()

    local line = ""
    local lsep = " ["
    local rsep = "] "
    local count = {}

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
            local name = vim.api.nvim_buf_get_name(buf)
            name = vim.fn.fnamemodify(name, ":t") -- filename only end
            if count[name] then
                count[name] = count[name] + 1
            else
                count[name] = 1
            end
        end
    end

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
            local name = vim.api.nvim_buf_get_name(buf)
            local stripped_name = vim.fn.fnamemodify(name, ":t") -- filename only end

            if name == "" then
                name = "UNNAMED"
            elseif count[stripped_name] > 1 then
                local parent = vim.fn.fnamemodify(name, ":h:t")  -- parent folder only
                local fname  = vim.fn.fnamemodify(name, ":t")    -- filename only
                if parent ~= "" then
                    name = parent .. "/" .. fname
                else
                    name = fname
                end
            else
                name = stripped_name
            end

            local modified = vim.api.nvim_buf_get_option(buf, "modified") and "*" or " "

            if deviconssetup then
                local icon, icon_hl = devicons.get_icon(stripped_name, vim.fn.fnamemodify(name, ":e"), { default = true })
                name = icon .. " " .. name
            end
            name = name .. modified

            if buf == current then
                line = line .. "%#Visual#" .. lsep .. name .. rsep
            else
                line = line .. "%#Comment#" .. lsep .. name .. rsep
            end
        end
    end
    line = line .. "%#Comment#"
    return line
end

-- Set it to show in the tabline
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.BufferLine()"

-- Expose function globally
_G.BufferLine = bufferline

