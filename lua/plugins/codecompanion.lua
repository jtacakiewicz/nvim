local setup, codecomp = pcall(require, 'codecompanion')
if not setup then return end
codecomp.setup({
    adapters = {
        opts = {
            show_defaults = false,
        },
        qwen = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "qwen", -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = {
                        default = "qwen2.5-coder:14b",
                    },
                    num_ctx = {
                        default = 1024,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
            })
        end,
        codestral = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "codestral", -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = {
                        default = "codestral",
                    },
                    num_ctx = {
                        default = 1024,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
            })
        end,
    },
    strategies = {
        chat = {
            adapter = "qwen",
        },
        inline = {
            adapter = "qwen",
        },
    },
})


-- Function to show a spinner while Ollama processes
local function show_spinner()
  local spinners = {"-", "/", "|", "\\"}
  local index = 1

  -- Create a timer to update the spinner
  local timer = vim.loop.new_timer()
  timer:start(100, 100, vim.schedule_wrap(function()
    local current_spinner = spinners[index]
    vim.o.statusline = "Processing with Ollama: " .. current_spinner
    index = (index % #spinners) + 1
  end))

  return timer
end

-- Function to hide the spinner after processing is done
local function hide_spinner(timer)
  timer:stop()
  timer:close()
  vim.o.statusline = ""
end

-- Example usage in your Ollama processing function
function process_with_ollama()
  local spinner_timer = show_spinner()

  -- Simulate Ollama processing with a sleep or async call
  -- Replace this with the actual Ollama processing code
  vim.defer_fn(function()
    -- Assume processing is done after some time
    hide_spinner(spinner_timer)
  end, 2000) -- Adjust the time as needed
end

-- Call the function to start processing
process_with_ollama()
