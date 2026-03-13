-- 2026-03-13
Cell.funcs.IterateAllUnitButtons(function(b)
    -- current health bar texture: Cell.vars.texture
    -- default health bar texture: "Interface\\AddOns\\Cell\\Media\\statusbar.tga"

    -- shield texture
    -- default: "Interface\\AddOns\\Cell\\Media\\shield.tga"
    b.widgets.shieldBar:SetTexture("Interface\\AddOns\\Cell\\Media\\shield.tga", "REPEAT", "REPEAT")
    b.widgets.shieldBarR:SetTexture("Interface\\AddOns\\Cell\\Media\\shield.tga", "REPEAT", "REPEAT")

    -- absorb texture (retail only, nil on Sirus)
    -- default: "Interface\\AddOns\\Cell\\Media\\shield.tga"
    if b.widgets.absorbsBar then
        b.widgets.absorbsBar:SetTexture("Interface\\AddOns\\Cell\\Media\\shield.tga", "REPEAT", "REPEAT")
    end
end)