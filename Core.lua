local addonName, addon = ...
local frame = CreateFrame("Frame")

-- List of Sound IDs to mute
-- These match the TBC/Retail sounds for the abilities we want to replace
local mutedSounds = {
    -- Vanish
    568893,
    -- Backstab
    569555,
    -- Ambush
    569555,

}

-- Map Spell Names to Sound Files
-- Ensure your sound files are in Interface/AddOns/RogueVanilla/Sounds/
local spellSounds = {
    ["Backstab"] = "Interface\\AddOns\\RogueVanilla\\Sounds\\Strike.ogg",
    ["Ambush"] = "Interface\\AddOns\\RogueVanilla\\Sounds\\Strike.ogg",
    ["Vanish"] = "Interface\\AddOns\\RogueVanilla\\Sounds\\Vanish.ogg",
}

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        -- Mute the unwanted sounds
        for _, soundID in ipairs(mutedSounds) do
            MuteSoundFile(soundID)
        end
        print("|cff00ff00RogueVanilla|r: Loaded. Sounds muted.")
    
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = CombatLogGetCurrentEventInfo()

        if subevent == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
            -- Check if we have a sound replacement for this spell
            if spellSounds[spellName] then
                PlaySoundFile(spellSounds[spellName], "SFX")
            end
        end
    end
end)
