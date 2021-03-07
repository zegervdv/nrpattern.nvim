local M = {}

local patterns = {
  {
    pattern = "(%d*)'h([%x_]+)",
    base = 16,
    format = "%s'h%x",
    separator = "_",
  },
  {
    pattern = "(%d*)'d([%d_]+)",
    base = 10,
    format = "%s'd%d",
    separator = "_",
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
  },
}

function match_word(text, col, incr)
  -- Inspired by nvim-cursorline.lua
  local cursorword, beginning, _ = unpack(vim.fn.matchstrpos(text:sub(1, col + 1), [[\k*$]]))
  cursorword = cursorword .. vim.fn.matchstr(text:sub(col + 1), [[^\k*]]):sub(2)

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
    start = col
    for _, option in ipairs(patterns) do
      local matchstart = text:find(option.pattern, col + 1)

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

  local s, e, prefix, value = text:find(match.pattern, start)
  if not value and prefix then
    value = prefix
    prefix = ""
  end
  local prexiflen = (e - s) - #value

  local has_separator = false
  if match.separator then
    value = value:gsub(match.separator, "")
    has_separator = true
  end
  value = tonumber(value, match.base) + incr

  new_value = string.format(match.format, prefix, value)

  new_line = text:sub(1, s - 1) .. new_value .. text:sub(e + 1)
  return new_line, s + #new_value
end

function M.increment(incr)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local text = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]

  new_line, offset = match_word(text, cursor[2], incr)
  if not new_line then
    return
  end

  vim.api.nvim_buf_set_lines(
    0,
    cursor[1] - 1, -- start row
    cursor[1], -- end row
    true,
    { new_line }
  )
  -- Match builtin behaviour, jump to last character of value
  vim.api.nvim_win_set_cursor(0, {cursor[1], offset - 2})
end

function M.increment_range(incr)
  local start_sel = vim.fn.getpos("'<")
  local end_sel = vim.fn.getpos("'>")

  -- No virtualedits
  if start_sel[4] == 1 or end_sel[4] == 1 then
    return
  end

  local start_line = math.min(start_sel[2], end_sel[2]) - 1
  local start_col = math.min(start_sel[3], end_sel[3])
  local end_line = math.max(start_sel[2], end_sel[2])

  local text = vim.api.nvim_buf_get_lines(0, start_line, end_line, true)
  local new_lines = {}
  for _, line in ipairs(text) do
    new_line, offset = match_word(line, start_col - 1, incr)
    if new_line then
      table.insert(new_lines, new_line)
    else
      table.insert(new_lines, line)
    end
  end

  vim.api.nvim_buf_set_lines(
    0,
    start_line,
    end_line,
    true,
    new_lines
  )
  -- Match builtin behaviour, jump to start of block (upper left corner)
  vim.api.nvim_win_set_cursor(0, {start_line + 1, start_col - 1})
end

return M
