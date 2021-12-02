local custom_actions  = require 'pairs.custom.actions'
local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

local M = {}

-- Default
-- if left and right are of the same char eg. quote
-- it would skip over if another pair is on the right of the cursor
M.open = {

  conditions = {

    function(pair)
      if pair.left == pair.right then
        if utils.get_right_char() == pair.right then
          return "jump"
        end
      end
    end,

    function(pair)
      if pair.left == pair.right and string.find(utils.get_left_char(), "[%w%p]") then
        return "no_auto_close"
      end
    end,

    function() return "always" end,
  },

  actions = {
    jump = custom_actions.jump_over,
    no_auto_close = custom_actions.no_auto_close,
    always = function(pair)
      local move_left = string.rep(keys.left, #pair.right)
      return pair.left .. pair.right .. move_left
    end
  }
}

-- Default
-- if closing pair is on the right of the cursor
-- it would skip over without inserting another closing pair
M.close = function(pair)
  if utils.get_right_char() == pair.right then
    return keys.right
  else
    return pair.right
  end
end

M.backspace = {

  condition = function(pair)
    local neighbours = utils.get_neighbours()
    if neighbours == pair.left .. pair.right then
      return true
    end
  end,

  action = function(pair)
    return keys.delete .. keys.backspace
  end,
}

return M
