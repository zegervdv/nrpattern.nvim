local M = {}

local patterns = {
  {
    pattern = "(%d*)'h([%x_]+)",
    base = 16,
    format = "%s'h%x",
  },
  {
    pattern = "(%d*)'d([%d_]+)",
    base = 10,
    format = "%s'd%d",
  },
  {
    pattern = "(0[xX])([%x]+)",
    base = 16,
    format = "%s%x",
  },
  {
    pattern = "(%d+)",
    base = 10,
    format = "%s%d",
  }
}


function M.increment(incr) 
  local cursor = vim.api.nvim_win_get_cursor(0)
  local text = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]

  -- Inspired by nvim-cursorline.lua
  local cursorword, beginning, _ = unpack(vim.fn.matchstrpos(text:sub(1, cursor[2] + 1), [[\k*$]]))
  cursorword = cursorword .. vim.fn.matchstr(text:sub(cursor[2] + 1), [[^\k*]]):sub(2)

  local start = 0
  local match = nil

  for _, option in ipairs(patterns) do
    if cursorword:match(option.pattern) then
      start = beginning
      match = option
      break
    end
  end

  if not match then
    start = cursor[2]
    for _, option in ipairs(patterns) do
      local matchstart = text:find(option.pattern, cursor[2] + 1)

      if matchstart then
        if not match or matchstart < start then
          start = matchstart - 1
          match = option
        end
      end
    end
  end

  if not match then
    return
  end

  local prefix, value = text:match(match.pattern, start)
  if not value and prefix then
    value = prefix
    prefix = ''
  end

  value = tonumber(value, match.base) + incr
  
  new_value = string.format(match.format, prefix, value)
  -- TODO: how to increase text range used?
  --       now it will overwrite trailing chars when new value is larger
  vim.api.nvim_buf_set_text(
    0,
    cursor[1] - 1, -- start row
    start, -- start col
    cursor[1] - 1, -- end row
    start + #new_value, -- end col
    { new_value }
  )
  vim.api.nvim_win_set_cursor(0, {cursor[1], start + #new_value - 1})
end

return M
