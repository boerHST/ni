local CreateFrame, UnitGUID, GetTime = CreateFrame, UnitGUID, GetTime

ni.frames.icdtracker = CreateFrame("Frame")
ni.frames.icdtracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local registeredevents = {
	["SPELL_AURA_APPLIED"] = true
}

ni.frames.icdtracker_OnEvent = function(
	self,
	event,
	timestamp,
	eventType,
	sourceGUID,
	sourceName,
	sourceFlags,
	destGUID,
	destName,
	destFlags,
	spellID,
	spellName,
	spellSchool,
	auraType)
	if not registeredevents[eventType] then
		return
	end

	if (eventType == "SPELL_AURA_APPLIED") then
		if sourceGUID == UnitGUID("player") and auraType == "BUFF" then
			for k, v in pairs(ni.icdtracker.timers) do
				if spellName == k then
					ni.icdtracker.timers[k].time = GetTime() + v.icd
				end
			end
		end
	end
end
