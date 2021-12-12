
lua << EOF

local utils = require 'pairs.utils'
local keys  = require 'pairs.keys'

require 'pairs'.setup {
  pairs = {
    markdown = {
      ["*"] = {
        left = "*",
        right = "*",
      }
    }


  }
}
