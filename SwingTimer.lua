-------------------------------------------------
-- 2026-03-13
-- add a swingTimer bar for each unitbutton
-------------------------------------------------
local SOURCE = "target"
local ONLY_SHOW_SOURCE = false

local POINT1, POINT1_X, POINT1_Y = "TOPLEFT", 0, 0
local POINT2, POINT2_X, POINT2_Y = "TOPRIGHT", 0, -5
local FRAME_LEVEL = 10
local COLOR = {1, 0, 0}

-------------------------------------------------
-- function codes
-------------------------------------------------
local F = Cell.funcs
local I = Cell.iFuncs
local P = Cell.pixelPerfectFuncs

local timers = {}

local function Display(b, sourceGUID)
    local GUID = UnitGUID(SOURCE)

    -- check SOURCE
    if GUID == sourceGUID and UnitCanAttack("player", SOURCE) then
        b.swingTimer:Display(SOURCE)
        timers[sourceGUID] = b.swingTimer
        b.swingTimer.lock = true

    -- if SOURCE not exists then check all nameplates
    elseif not (ONLY_SHOW_SOURCE or b.swingTimer.lock) then
        for i = 1, 40 do
            local token = "nameplate"..i
            if UnitExists(token) and UnitGUID(token) == sourceGUID then
                b.swingTimer:Display(token)
                timers[sourceGUID] = b.swingTimer
                break
            end
        end
    end
end

F.IterateAllUnitButtons(function(b)
    local swingTimer = I.CreateAura_Bar(b:GetName().."SwingTimer", b.widgets.indicatorFrame)
    b.swingTimer = swingTimer
    swingTimer:Hide()
    swingTimer:SetPoint(POINT1, P.Scale(POINT1_X), P.Scale(POINT1_Y))
    swingTimer:SetPoint(POINT2, P.Scale(POINT2_X), P.Scale(POINT2_Y))
    swingTimer:SetStatusBarColor(unpack(COLOR))
    swingTimer:SetFrameLevel(b.widgets.indicatorFrame:GetFrameLevel()+FRAME_LEVEL)

    function swingTimer:Display(sourceUnit)
        local speed = UnitAttackSpeed(sourceUnit)
        swingTimer:SetMinMaxValues(0, speed)
        swingTimer:SetValue(speed)

        local start = GetTime()
        swingTimer:SetScript("OnUpdate", function()
            local remain = speed-(GetTime()-start)
            if remain >= 0 then
                swingTimer:SetValue(remain)
            else
                swingTimer.lock = nil
                swingTimer:Hide()
            end
        end)
        swingTimer:Show()
    end
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    local _, subEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
    if subEvent == "SWING_DAMAGE" or subEvent == "SWING_MISSED" then
        F.HandleUnitButton("guid", destGUID, Display, sourceGUID)
    elseif subEvent == "UNIT_DIED" then
        if timers[destGUID] then
            timers[destGUID]:Hide()
            timers[destGUID] = nil
        end
    end
end)

Cell.RegisterCallback("LeaveInstance", "CellSwingTimer_LeaveInstance", function()
    for _, t in pairs(timers) do
        t:Hide()
    end
    wipe(timers)
end)