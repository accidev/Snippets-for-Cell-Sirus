
local filters = {
    -- ["spellName"] = {
    --     ["TANK"] = true,
    --     ["HEALER"] = true,
    --     ["DAMAGER"] = true,
    -- },
}

local I = Cell.iFuncs
local _UpdateCustomIndicators = I.UpdateCustomIndicators

function I.UpdateCustomIndicators(unitButton, auraType, spellId, spellName, start, duration, debuffType, icon, count, refreshing, castByMe)
    if auraType == "buff" and filters[spellName] then
        local role = unitButton.states.role
        if role and role ~= "NONE" and not filters[spellName][role] then
            return
        end
    end

    return _UpdateCustomIndicators(unitButton, auraType, spellId, spellName, start, duration, debuffType, icon, count, refreshing, castByMe)
end
