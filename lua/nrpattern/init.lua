local M = {}
local bigint = require"nrpattern.vendor.BigInteger"
local patterns = {}

local last_range_size = 0

function parse_value(value, base, increment)
  sign = "+"
  if value:sub(1, 1) == "-" then
    sign = "-"
  end
  val = bigint:new(value, sign, base)

  if increment >= 0 then
    sign = "+"
  else
    sign = "-"
  end
  return val:add(bigint:new(string.format("%d", increment), sign))
end

function format_value(value, base)
  local new_value = value:toString(base):lower()
  if #new_value == 0 then
    new_value = "0"
  end
  return new_value
end

function update_numeric(match, start, text, incr)
  local s, e, prefix, value = text:find(match.pattern, start)
  if not value and prefix then
    value = prefix
    prefix = ""
  end
  local prexiflen = (e - s) - #value

  local has_separator = false
  if match.separator and value:find(match.separator.char) then
    value = value:gsub(match.separator.char, "")
    has_separator = true
  end
  local parsed_value = parse_value(value, match.base, incr)

  local value_formatted = format_value(parsed_value, match.base)

  if has_separator then
    local substring = ""
    for i = 1, math.ceil(#value_formatted / match.separator.group) do
      local low = #value_formatted - i * match.separator.group + 1
      local high = #value_formatted - (i - 1) * match.separator.group

      if low < 0 then
        low = 0
      end

      local slice = value_formatted:sub(low, high)
      if i == 1 then
        substring = slice
      else
        substring = slice .. match.separator.char .. substring
      end
    end

    value_formatted = substring
  end

  new_value = string.format(match.format, prefix, value_formatted)
  
  return new_value, s, e
end

function update_cyclic(match, start, text, incr)
  local matchstart = nil

  for i, word in ipairs(match.pattern) do
    local m, s, e = unpack(vim.fn.matchstrpos(text, [[\<]] .. word .. [[\>]], start - 1))
    if s == start then
      if i >= #match.pattern then
        i = 0
      end
      local new_value = match.pattern[i + 1]

      return new_value, s + 1, e
    end
  end
end

function match_word(text, col, incr)
  -- Inspired by nvim-cursorline.lua
  local cursorword, beginning, _ = unpack(vim.fn.matchstrpos(text:sub(1, col + 1), [[\k*$]]))
  cursorword = cursorword .. vim.fn.matchstr(text:sub(col + 1), [[^\k*]]):sub(2)

  local start = 0
  local match = nil

  for _, option in ipairs(patterns) do
    if option.filetypes == nil or vim.tbl_contains(option.filetypes, vim.bo.filetype) then
      if option.cyclic then
        if vim.tbl_contains(option.pattern, cursorword) then
          start = beginning
          match = option
          break
        end
      else
        if cursorword:match(option.pattern) then
          start = beginning
          match = option
          break
        end
      end
    end
  end

  if not match then
    start = col
    for _, option in ipairs(patterns) do
      if option.filetypes == nil or vim.tbl_contains(option.filetypes, vim.bo.filetype) then
        local matchstart = nil

        if option.cyclic then
          for _, word in ipairs(option.pattern) do
            local m, s, _ = unpack(vim.fn.matchstrpos(text, [[\<]] .. word .. [[\>]], col - 1))
            if m ~= "" then
              matchstart = s + 1
              break
            end
          end
        else
          matchstart = text:find(option.pattern, col + 1)
        end

        if matchstart then
          if not match or matchstart < start then
            start = matchstart - 1
            match = option
          end
        end
      end
    end
  end

  if not match then
    return
  end

  local new_value, s, e
  if match.cyclic then
    new_value, s, e = update_cyclic(match, start, text, incr)
  else
    new_value, s, e = update_numeric(match, start, text, incr)
  end

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

function M.increment_range(incr, multiply, repeats)
  local start_line = nil
  local start_col = nil
  local end_line = nil

  if not repeats then
    local start_sel = vim.fn.getpos("'<")
    local end_sel = vim.fn.getpos("'>")

    -- No virtualedits
    if start_sel[4] == 1 or end_sel[4] == 1 then
      return
    end

    start_line = math.min(start_sel[2], end_sel[2]) - 1
    start_col = math.min(start_sel[3], end_sel[3]) - 1
    end_line = math.max(start_sel[2], end_sel[2])

    last_range_size = end_line - start_line
  else
    local start_sel = vim.api.nvim_win_get_cursor(0)

    start_line = start_sel[1] - 1
    start_col = start_sel[2]
    end_line = start_line + last_range_size
  end

  local text = vim.api.nvim_buf_get_lines(0, start_line, end_line, true)
  local new_lines = {}
  for i, line in ipairs(text) do
    local increment = incr;
    if multiply then
      increment = incr * i
    end

    new_line, offset = match_word(line, start_col, increment)
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
  vim.api.nvim_win_set_cursor(0, {start_line + 1, start_col})
end

function priority_sort(el1, el2)
  return el1.priority < el2.priority
end

function M.setup(config)
  if config == nil then
    config = require"nrpattern.default"
  end

  for pattern, opts in pairs(config) do
    opts.pattern = pattern
    if vim.tbl_islist(pattern) then
      opts.cyclic = true
      opts.format = "%s%s"
    end
    table.insert(patterns, opts)
  end

  table.sort(patterns, priority_sort)
end

return M
