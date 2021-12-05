
local M = {}

function M.get_neighbours()
  return M.get_left_char() .. M.get_right_char()
end

function M.get_right_char()
  local line = vim.api.nvim_get_current_line()
  local col  = vim.api.nvim_win_get_cursor(0)[2]

  local right = vim.fn.strpart(line, col, 1)

  return right
end

function M.get_left_char()
  local line = vim.api.nvim_get_current_line()
  local col  = vim.api.nvim_win_get_cursor(0)[2]

  local left  = vim.fn.strpart(line, col - 1, 1)

  return left
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode, true)
end

function M.escape(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

return M
