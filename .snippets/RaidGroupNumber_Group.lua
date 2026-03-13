-------------------------------------------------
-- 2026-03-13
-- show raid group numbers above headers
-------------------------------------------------
for i = 1, 8 do
    local header = _G["CellRaidFrameHeader"..i]
    if header and header[1] then
        header.groupNumber = header[1]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header.groupNumber:SetPoint("BOTTOM", header, "TOP", 0, 2)
        header.groupNumber:SetText("Group "..i)
    end
end