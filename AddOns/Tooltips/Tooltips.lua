Tooltips = {}

local NUMBER_PATTERN = '%d[%d,]*%.?%d*'

local tooltip = CreateFrame('GameTooltip', 'TooltipsTooltip', UIParent, 'GameTooltipTemplate')
tooltip:SetOwner(UIParent, 'ANCHOR_NONE')

local function isClassAbility()
  local textLeft2 = TooltipsTooltipTextLeft2:GetText()
  return textLeft2 == 'Class Ability'
end

Tooltips.retrieveSpellTooltipText = function(spellId)
  tooltip:SetSpellByID(spellId)
  local index
  if TooltipsTooltipTextLeft2:GetText() == 'Instant' then
    index = 3
  elseif isClassAbility() then
    index = 5
  else
    index = 4
  end
  local text = _G['TooltipsTooltipTextLeft' .. tostring(index)]:GetText()
  if string.match(text, '^Cooldown remaining: ') or string.match(text, '^Recharging: ') then
    index = index + 1
  end
  local elementWithSpellDescription = _G['TooltipsTooltipTextLeft' .. tostring(index)]
  return elementWithSpellDescription:GetText()
end

local function convertStringToNumber(text)
  return tonumber(string.gsub(text, ',', ''), 10)
end

Tooltips.retrieveSpellCost = function(spellId)
  tooltip:SetSpellByID(spellId)
  local costText = TooltipsTooltipTextLeft2:GetText()
  local costNumberText = string.match(costText, NUMBER_PATTERN)
  local cost = convertStringToNumber(costNumberText)
  return cost
end

Tooltips.retrieveSpellCastDuration = function(spellId)
  tooltip:SetSpellByID(spellId)
  local durationText = TooltipsTooltipTextLeft3:GetText()
  local duration
  if durationText == 'Instant' then
    duration = 0
  else
    local durationNumberText = string.match(durationText, NUMBER_PATTERN)
    duration = convertStringToNumber(durationNumberText)
  end
  return duration
end

Tooltips.retrieveNThNumber = function(text, n)
  local match
  local matcher = string.gmatch(text, NUMBER_PATTERN)
  for i = 1, n do
    match = matcher()
  end
  return convertStringToNumber(match)
end

Tooltips.retrieveItemTooltipText = function(itemID)
  tooltip:SetItemByID(itemID)

  if TooltipsTooltipTextLeft3 then
    local text = TooltipsTooltipTextLeft3:GetText()
    if text == 'Binds when picked up' then
      text = TooltipsTooltipTextLeft4:GetText()
    end
    return text
  else
    -- Can happen when the function is called before the tooltip is loaded.
    return nil
  end
end
