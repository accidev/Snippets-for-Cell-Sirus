-------------------------------------------------
-- 2026-03-13
-- remove icons border
-------------------------------------------------
local create = Cell.iFuncs.CreateAura_BarIcon
Cell.iFuncs.CreateAura_BarIcon = function(name, parent)
    local f = create(name, parent)
    hooksecurefunc(f, "SetCooldown", function()
        f:SetBackdropColor(0, 0, 0, 0)
    end)
    return f
end