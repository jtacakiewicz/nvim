local M = {}
local API_URL = os.getenv("CHAT_BASE_URL") or "http://localhost:1147"
local API_KEY = os.getenv("CHAT_API_KEY") or ""
local MODEL = os.getenv("MODEL") or "*"

local marker_ns = vim.api.nvim_create_namespace("visual_marker")
local instruction_ns = vim.api.nvim_create_namespace("llm_instruction")
SYSTEM_PROMPT =  "You are a code refactoring tool. Rewrite the provided code based on the instruction. Output ONLY the raw replaced code. Do NOT wrap the result in markdown code fences. Do NOT write explanations."
M.tools = {
  {
    type = "function",
    ["function"] = {
      name = "findd",
      description = "Find files by name matching using `findd`. Paths are relative to the root directory of project.",
      parameters = {
        type = "object",
        properties = {
          pattern = {
            type = "string",
            description = "Pattern to match against file names (e.g. '*.lua' or 'manager').",
          },
          path = {
            type = "string",
            description = "Directory to search, relative to the project root directory. Defaults to '.'",
          },
        },
        required = { "pattern" },
      },
    },
  },
  {
    type = "function",
    ["function"] = {
      name = "rg",
      description = "Search file contents with `grep`. Paths are relative to the root directory of project.",
      parameters = {
        type = "object",
        properties = {
          pattern = {
            type = "string",
            description = "Regex pattern to search for.",
          },
          path = {
            type = "string",
            description = "File or directory to search, relative to the project root directory. Defaults to '.'",
          },
        },
        required = { "pattern" },
      },
    },
  },
  {
    type = "function",
    ["function"] = {
      name = "ls",
      description = "List files and directories. Paths are relative to the root directory of project.",
      parameters = {
        type = "object",
        properties = {
          path = {
            type = "string",
            description = "File or directory to list, relative to the project root directory. Defaults to '.'",
          },
        },
        required = {},
      },
    },
  },
  {
    type = "function",
    ["function"] = {
      name = "read_file_range",
      description = "Read a specific line range from a file. Paths are relative to the root directory of project.",
      parameters = {
        type = "object",
        properties = {
          path = {
            type = "string",
            description = "Path to the file, relative to the project root directory.",
          },
          start_line = {
            type = "integer",
            description = "First line to read (1-based, inclusive).",
          },
          end_line = {
            type = "integer",
            description = "Last line to read (1-based, inclusive).",
          },
        },
        required = { "path", "start_line", "end_line" },
      },
    },
  },
}

local function create_prompt(bufnr, instruction, selected_text)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    file = "[No Name]"
  end

  local start_line, end_line
  local mode = vim.fn.mode(1)
  if mode == "v" or mode == "V" or mode == "\22" then
    local s = vim.api.nvim_buf_get_mark(bufnr, "<")
    local e = vim.api.nvim_buf_get_mark(bufnr, ">")
    start_line, end_line = s[1], e[1]
  else
    local cursor = vim.api.nvim_win_get_cursor(0)
    start_line, end_line = cursor[1], cursor[1]
  end
  if start_line == 0 then start_line = 1 end
  if end_line == 0 then end_line = start_line end

  return {
    {
      role = "system",
      content = SYSTEM_PROMPT,
    },
    {
      role = "system",
      content = string.format(
        "From file %s, lines %d-%d.",
        file,
        start_line,
        end_line
      ),
    },
    {
      role = "user",
      content = string.format("Instruction: %s\n\nCode to rewrite:\n%s", instruction, selected_text),
    },
  }
end


local function sanitize_hl_group(name)
  if type(name) ~= "string" or name == "" then
    return nil
  end
  local sanitized = name:gsub("[^%w_]", "_")
  if sanitized:match("^%d") then
    sanitized = "_" .. sanitized
  end
  return sanitized
end

local function ensure_hl_group(color)
  local hl_group = sanitize_hl_group(color)
  if not hl_group then
    return nil
  end
  local hex = color:gsub("^#", "")
  if not hex:match("^%x%x%x%x%x%x$") then
    return nil
  end
  vim.api.nvim_set_hl(0, hl_group, { bg = "#" .. hex })
  return hl_group
end

local function add_visual_marker(line_begin, line_end, color)
  local bufnr = vim.api.nvim_get_current_buf()
  local hl_group = ensure_hl_group(color)
  if not hl_group then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, marker_ns, line_begin - 1, line_end)
  for line = line_begin, line_end do
    vim.api.nvim_buf_set_extmark(bufnr, marker_ns, line - 1, 0, {
      sign_text = "  ",
      sign_hl_group = hl_group,
    })
  end
end

local function remove_visual_marker(line_begin, line_end)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, marker_ns, line_begin - 1, line_end)
end

local function clean_markdown(text)
  text = text:gsub("^```%w*\n", ""):gsub("\n```$", ""):gsub("^```", ""):gsub("```$", "")
  return text
end

local MAX_TOOL_CALLS = 5

local function run_tool_command(cmd)
  local obj = vim.system(cmd, { text = true }):wait()
  local out = obj.stdout or ""
  if obj.code ~= 0 and obj.stderr and obj.stderr ~= "" then
    out = out .. "\n" .. obj.stderr
  end
  return out
end

local function execute_tool(name, arguments)
  local ok, args = pcall(vim.json.decode, arguments or "{}")
  if not ok or type(args) ~= "table" then
    args = {}
  end

  if name == "findd" then
    local pattern = args.pattern or "*"
    local path = args.path or "."
    return run_tool_command({ "find", path, "-name", pattern })
  elseif name == "rg" then
    local pattern = args.pattern or ""
    local path = args.path or "."
    return run_tool_command({ "rg", "-n", pattern, path })
  elseif name == "ls" then
    local path = args.path or "."
    return run_tool_command({ "ls", "-la", path })
  elseif name == "read_file_range" then
    local path = args.path
    local start_line = tonumber(args.start_line) or 1
    local end_line = tonumber(args.end_line) or start_line
    return run_tool_command({ "sed", "-n", string.format("%d,%dp", start_line, end_line), path })
  end

  return "Unknown tool: " .. tostring(name)
end

local function perform_request(messages, tool_call_count, on_final)
  local payload = {
    model = MODEL,
    messages = messages,
    temperature = 0.2,
    tools = M.tools,
    tool_choice = "auto",
  }

  local log_path = vim.fn.stdpath("state") .. "/agent.log"

  local function write_log(entry)
    local f = io.open(log_path, "a")
    if f then
      f:write(string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), entry))
      f:close()
    end
  end

  write_log("PROMPT: " .. vim.json.encode(messages))

  vim.system(
    {
      "curl",
      "-s",
      "-X", "POST",
      API_URL .. '/v1/chat/completions',
      "-H", "Content-Type: application/json",
      "-H", "Authorization: Bearer " .. API_KEY,
      "-d", vim.json.encode(payload),
    },
    { text = true },
    function(obj)
      vim.schedule(function()
        if obj.code ~= 0 then
          vim.notify("cURL request failed: " .. (obj.stderr or "Unknown error"), vim.log.levels.ERROR)
          return
        end

        local ok, response = pcall(vim.json.decode, obj.stdout)
        if not ok or not response or not response.choices or #response.choices == 0 then
          vim.notify("Invalid API response: " .. (obj.stdout or "Empty response"), vim.log.levels.ERROR)
          return
        end

        local message = response.choices[1].message or {}
        local tool_calls = message.tool_calls

        if tool_calls and #tool_calls > 0 and tool_call_count < MAX_TOOL_CALLS then
          table.insert(messages, {
            role = "assistant",
            content = message.content,
            tool_calls = tool_calls,
          })

          for _, tc in ipairs(tool_calls) do
            local fn = tc["function"] or {}
            write_log(string.format("TOOL CALL: %s(%s)", fn.name or "?", fn.arguments or ""))
            local result = execute_tool(fn.name, fn.arguments)
            table.insert(messages, {
              role = "tool",
              tool_call_id = tc.id,
              content = result,
            })
          end

          perform_request(messages, tool_call_count + 1, on_final)
        else
          on_final(message.content or "")
        end
      end)
    end
  )
end

function M.show_logs()
  local log_path = vim.fn.stdpath("state") .. "/agent.log"
  if vim.fn.filereadable(log_path) == 0 then
    vim.notify("No agent logs found at " .. log_path, vim.log.levels.WARN)
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(log_path))
end

function M.rewrite_selection()
 local mode = vim.fn.visualmode()
  vim.cmd("noautocmd normal! \27")

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  local bufnr = vim.api.nvim_get_current_buf()

  if mode == "V" then
    start_col = 0
    local end_line_text = vim.api.nvim_buf_get_lines(bufnr, end_line, end_line + 1, false)[1] or ""
    end_col = #end_line_text
  else
    local start_line_text = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""
    local end_line_text = vim.api.nvim_buf_get_lines(bufnr, end_line, end_line + 1, false)[1] or ""

    start_col = math.max(0, math.min(start_col, #start_line_text))
    end_col = math.max(0, math.min(end_col, #end_line_text))
  end

  local lines = vim.api.nvim_buf_get_text(bufnr, start_line, start_col, end_line, end_col, {})
  local selected_text = table.concat(lines, "\n")

  local ns = vim.api.nvim_create_namespace("llm_rewrite")
  local ext_id = vim.api.nvim_buf_set_extmark(bufnr, ns, start_line, start_col, {
    end_line = end_line,
    end_col = end_col,
  })
  add_visual_marker(start_line, end_line, vim.g.terminal_color_4)

  vim.ui.input({ prompt = "LLM Edit Instruction: " }, function(instruction)
    if not instruction or instruction == "" then
      vim.api.nvim_buf_del_extmark(bufnr, ns, ext_id)
      remove_visual_marker(start_line - 1, end_line)
      return
    end


    local instr_ext_id = vim.api.nvim_buf_set_extmark(bufnr, instruction_ns, start_line - 1, 0, {
      virt_text = { { " $> " .. instruction, "Comment" } },
      virt_text_pos = "eol",
    })

    local messages = create_prompt(bufnr, instruction, selected_text)

    perform_request(messages, 0, function(result_text)
      pcall(vim.api.nvim_buf_del_extmark, bufnr, instruction_ns, instr_ext_id)

      result_text = clean_markdown(result_text)

      local mark = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, ext_id, { details = true })
      if mark and #mark >= 2 then
        local new_start_line, new_start_col = mark[1], mark[2]
        local new_end_line = mark[3].end_row
        local new_end_col = mark[3].end_col
        remove_visual_marker(new_start_line, new_end_line)

        local new_lines = vim.split(result_text, "\n", { plain = true })
        vim.api.nvim_buf_set_text(bufnr, new_start_line, new_start_col, new_end_line, new_end_col, new_lines)
      end
    end)
  end)
end
return M
