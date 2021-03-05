local M = {}

local bases = {
  h = 16,
  b = 2,
  d = 10,
}

local pattern = "(%d*)'([hdb])([%d%a_]+)"

function M.increment(incr) 
  local cursor = vim.api.nvim_win_get_cursor(0)
  local text = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]

  -- Copied from nvim-cursorline.lua
  local cursorword = vim.fn.matchstr(text:sub(1, cursor[2] + 1), [[\k*$]]) .. vim.fn.matchstr(text:sub(cursor[2] + 1), [[^\k*]]):sub(2)
  local start = 0
  if cursorword:match(pattern) then
    _, start, _ = unpack(vim.fn.matchstrpos(text:sub(1, cursor[2] + 1), [[\k*$]]))
  else
    start = text:find(pattern, cursor[2]) - 1
  end
  print('Jumped to ' .. start)

  local prefix, base, value = text:match(pattern, start)
  print(prefix .. ' + ' .. base .. ' + ' .. value)
  value = tonumber(value, bases[base]) + incr
  

  new_value = string.format("%s'%s%x", prefix, base, value)
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
