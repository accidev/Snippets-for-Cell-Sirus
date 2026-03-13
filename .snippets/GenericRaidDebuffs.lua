---------------------------------------------------------------------
-- show these debuffs as Raid Debuffs in M+ with HIGHEST priority
local debuffs = {
    -- WotLK M+ spell IDs (fill in as needed)
    -- example: 48438, -- Ebon Plague (Death Knight)
    -- example: 55078, -- Blood Plague (Death Knight)
}

-- enabled in these instances as well (by instance map ID)
-- WotLK instance IDs:
--   533 = Naxxramas
--   615 = The Obsidian Sanctum
--   616 = The Eye of Eternity
--   624 = Vault of Archavon
--   631 = Icecrown Citadel
--   649 = Trial of the Crusader
--   724 = The Ruby Sanctum
local instances = {
    -- [631] = true, -- Icecrown Citadel
}
---------------------------------------------------------------------

local F = Cell.funcs
local offset = #debuffs

-- Both tables are populated by reference — safe to capture at load time.
-- Cell.snippetVars.instanceNameMapping and .loadedDebuffs are set in
-- RaidDebuffs.lua before snippets run (lines 24 and 70).
local instanceNameMapping = Cell.snippetVars.instanceNameMapping

-- Cache original so we can call it.
local _GetDebuffList = F.GetDebuffList

function F.GetDebuffList(instanceName)
    -- Start with the base list from the real implementation.
    local list = _GetDebuffList(instanceName)

    if not instanceName then
        return list
    end

    local result = instanceNameMapping[instanceName]
    if not result then
        return list
    end

    local eName, iIndex, iId = F.SplitToNumber(":", result)

    -- On Sirus, M+ is detected via C_MythicPlus.IsMythicPlusActive().
    -- instances[] allows forcing extra debuffs in specific non-M+ instances too.
    local isMythicPlus = C_MythicPlus and C_MythicPlus.IsMythicPlusActive()

    if isMythicPlus or instances[iId] then
        for i, id in ipairs(debuffs) do
            -- Insert at the front by using negative order values so these
            -- always sort before the regular debuffs (order 1+).
            list[id] = { ["order"] = i - offset - 1, ["condition"] = { "None" } }
        end
    end

    return list
end
