local keys  = require 'pairz.keys'
local utils = require 'pairz.utils'


local M = {}

function M.open_pair(pair)

  utils.feedkey(pair.left .. pair.right, "n")

  for i = 1, #pair.right do
    utils.feedkey("<left>", "n")
  end

end

function M.delete_left_and_right()
  utils.feedkey("<Del>", "n")
  utils.feedkey("<BS>", "n")
end

function M.enter_and_indent()
  utils.feedkey("<CR><CR>", "n")
  utils.feedkey("<Up>", "n")
  utils.feedkey("<C-F>", "n")
end

function M.expand_with_space(pair)

  local pos = vim.fn.searchpos(pair.right, 'nc', vim.fn.line('.'))
  local lnum, col = pos[1], pos[2]

  vim.api.nvim_buf_set_text(0, lnum - 1, col - 1, lnum - 1, col - 1, {' '} )

  utils.feedkey(" ", "n")
end

function M.jump_over(pair)
  utils.feedkey("<right>", "n")
end

function M.no_auto_close(pair)
  utils.feedkey(pair.left, "n")
end


return M