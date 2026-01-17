local addonName, addon = ...
local frame = CreateFrame("Frame")

-- List of Sound IDs to mute
-- These match the TBC/Retail sounds for the abilities we want to replace
local mutedSounds = {
    -- Vanish
    568893,
    -- Backstab / Ambush (Retail/TBC sound)
    569555,
    --test stealth
    -- 569423,
}

-- Map Spell Names to Sound IDs (File IDs)
-- These are internal game sounds (Vanilla versions)
local spellSounds = {
    ["Backstab"] = 569059, -- Strike.ogg
    ["Ambush"] = 569059,
    ["Vanish"] = 568798,
}

local isEnabled = true

local function MuteAll()
    for _, soundID in ipairs(mutedSounds) do
        MuteSoundFile(soundID)
    end
end

local function UnmuteAll()
    for _, soundID in ipairs(mutedSounds) do
        UnmuteSoundFile(soundID)
    end
end

-- Slash command to toggle the addon
SLASH_ROGUEVANILLA1 = "/rv"
SlashCmdList["ROGUEVANILLA"] = function(msg)
    isEnabled = not isEnabled
    if isEnabled then
        MuteAll()
        print("|cff00ff00RogueVanilla|r: Enabled. Sounds muted.")
    else
        UnmuteAll()
        print("|cffff0000RogueVanilla|r: Disabled. Sounds unmuted.")
    end
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            MuteAll()
            print("|cff00ff00RogueVanilla|r: Loaded. Type /rv to toggle.")
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Always unmute on logout/reload so sounds aren't stuck muted if you disable the addon
        UnmuteAll()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" and isEnabled then
        local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool =
            CombatLogGetCurrentEventInfo()

        if subevent == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
            -- Check if we have a sound replacement for this spell
            if spellSounds[spellName] then
                PlaySoundFile(spellSounds[spellName], "SFX")
            end
        end
    end
end)
