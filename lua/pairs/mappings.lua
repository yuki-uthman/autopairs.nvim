local default  = require 'pairs.default.actions'
local fallback = require 'pairs.default.fallback'
local utils    = require 'pairs.utils'
local keys     = require 'pairs.keys'

local M = {}

function M.open(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  if pair.open and pair.open.action then
    return pair.open.action(pair)
  else
    return default.open(pair)
  end

end

function M.close(type)

  -- return the pair table
  -- eg. single_quote, parenthesis, etc
  local pair = Pairs.pairs[type]

  if pair.close and pair.close.action then
    return pair.close.action(pair)
  else
    return default.close(pair)
  end

end

function M.backspace()

  local neighbours = utils.get_neighbours()

  for _, pair in pairs(Pairs.pairs) do

    -- if custom backspace is not implemented
    if not pair.backspace then

      -- check for default backspace condition
      if default.backspace.condition(pair) then
        return default.backspace.action(pair)
      end

      -- if no default backspace skip to the next pair
      goto next
    end

    for _, condition in ipairs(pair.backspace.conditions) do
      local condition = condition(pair)
      if condition then
        return pair.backspace.actions[condition](pair)
      end
    end

    ::next::
  end

  if fallback.backspace then
    return fallback.backspace()
  else
    return keys.backspace
  end

end

function M.enter()

  -- get char left and right of the cursor
  local neighbours = utils.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs.pairs) do

    -- skip if enter is not implemented
    if not pair.enter then
      goto next
    end

    if pair.enter.condition and pair.enter.condition() then
      return pair.enter.action(pair)
    end

    ::next::
  end

  if fallback.enter then
    return fallback.enter()
  else
    return keys.enter
  end
end

function M.space()

  -- get char open.key and close.key of the cursor
  local neighbours = utils.get_neighbours()

  -- if the pair matches any pairs
  for _, pair in pairs(Pairs.pairs) do

    -- skip if space is not implemented
    if not pair.space then
      goto next
    end

    if pair.space.condition and pair.space.condition() then
      return pair.space.action(pair)
    end

    ::next::
  end

  if fallback.space then
    return fallback.space()
  else
    return keys.space
  end
end

return M
