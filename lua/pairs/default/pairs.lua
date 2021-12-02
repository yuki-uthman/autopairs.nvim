local custom_actions    = require "pairs.custom.actions"
local custom_conditions = require "pairs.custom.conditions"

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

local M = {}

M.single_quote = {
  left = "'",
  right = "'",
  open = {
    conditions = {
      custom_conditions.left_is_backward_slash,
      custom_conditions.right_is_close_pair,
      custom_conditions.left_is_alhanumeric,
      function() return "all" end,
    },

    actions = {
      left_is_backward_slash = custom_actions.no_auto_close,
      right_is_close_pair    = custom_actions.jump_over,
      left_is_alhanumeric    = custom_actions.no_auto_close,
      all = function(pair)
        return pair.left .. pair.right .. keys.left
      end
    }
  },

  backspace = {
    conditions = {
      custom_conditions.empty,
    },

    actions = {
      empty = custom_actions.delete_left_and_right
    }
  },
}

M.double_quote = {
  left = "\"",
  right = "\"",
  open = {
    conditions = {
      custom_conditions.left_is_backward_slash,
      custom_conditions.right_is_close_pair,
      custom_conditions.left_is_alhanumeric,
      function() return "all" end,
    },

    actions = {
      left_is_backward_slash = custom_actions.no_auto_close,
      right_is_close_pair    = custom_actions.jump_over,
      left_is_alhanumeric    = custom_actions.no_auto_close,
      all = function(pair)
        return pair.left .. pair.right .. keys.left
      end
    }
  },

  backspace = {
    conditions = {
      custom_conditions.empty,
    },

    actions = {
      empty = custom_actions.delete_left_and_right
    }
  },
}

M.parenthesis = {
  left = "(",
  right = ")",

  close = {
    conditions = {
      custom_conditions.right_is_close_pair
    },
    actions = {
      right_is_close_pair = custom_actions.jump_over
    }
  },

  backspace = {
    conditions = {
      custom_conditions.empty,
    },

    actions = {
      empty = custom_actions.delete_left_and_right
    }
  },

  enter = {
    conditions = {
      custom_conditions.right_is_close_pair
    },

    actions = {
        right_is_close_pair = function(pair)
        -- find the position of opening parenthesis
        local pos = vim.fn.searchpairpos('(', '', ')', 'bn')
        local line, col = pos[1], pos[2]

        local current_line = vim.api.nvim_win_get_cursor(0)[1]

        local indent_level = current_line - line + 1
        local indent = string.rep("  ", indent_level)

        -- next line starts from the opening parenthesis col like in cindent
        local extra_space = string.rep(" ", col - 1) .. indent

        -- delete the whole line and add the space to accomodate
        -- different indent styles across file types
        return keys.enter .. keys.delete_line .. extra_space
      end
    }

  },

  space = {
    conditions = {
      custom_conditions.empty
    },

    actions = {
      empty = custom_actions.expand_with_space
    }
  }
}

M.curly_braces = {
  left = "{",
  right = "}",

  close = {
    conditions = {
      custom_conditions.right_is_close_pair
    },
    actions = {
      right_is_close_pair = custom_actions.jump_over
    }
  },

  backspace = {
    conditions = {
      custom_conditions.empty,
    },

    actions = {
      empty = custom_actions.delete_left_and_right
    }
  },

  enter = {
    conditions = {
      custom_conditions.empty
    },
    
    actions = {
      empty = custom_actions.enter_and_indent
    }
  },

  space = {
    conditions = {
      custom_conditions.empty
    },

    actions = {
      empty = custom_actions.expand_with_space
    }
  }

}

M.tilda = {
  left = "`",
  right = "`",
}


return M
