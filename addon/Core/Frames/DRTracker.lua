local CreateFrame, UnitCanAttack, IsInInstance, GetFramerate = CreateFrame, UnitCanAttack, IsInInstance, GetFramerate

ni.frames.drtracker = CreateFrame("Frame")
ni.frames.drtracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ni.frames.drtracker:RegisterEvent("PLAYER_LEAVING_WORLD")

local registeredevents = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["PARTY_KILL"] = true,
	["UNIT_DIED"] = true
}

ni.frames.drtracker_OnEvent = function(
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
	if (not registeredevents[eventType]) then
		return
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		-- Enemy gained a debuff
		if (eventType == "SPELL_AURA_APPLIED") then
			-- Enemy had a debuff refreshed before it faded, so fade + gain it quickly
			if (auraType == "DEBUFF" and ni.tables.dr.spells[spellID]) then
				ni.drtracker.gained(spellID, destName, destGUID, UnitCanAttack("player", destGUID), destGUID)
			end
		elseif (eventType == "SPELL_AURA_REFRESH") then
			-- Buff or debuff faded from an enemy
			if (auraType == "DEBUFF" and ni.tables.dr.spells[spellID]) then
				ni.drtracker.faded(spellID, destName, destGUID, UnitCanAttack("player", destGUID), destGUID)
				ni.drtracker.gained(spellID, destName, destGUID, UnitCanAttack("player", destGUID), destGUID)
			end
		elseif (eventType == "SPELL_AURA_REMOVED") then
			-- Don't use UNIT_DIED inside arenas due to accuracy issues, outside of arenas we don't care too much
			if (auraType == "DEBUFF" and ni.tables.dr.spells[spellID]) then
				ni.drtracker.faded(spellID, destName, destGUID, UnitCanAttack("player", destGUID), destGUID)
			end
		elseif ((eventType == "UNIT_DIED" and select(2, IsInInstance()) ~= "arena") or eventType == "PARTY_KILL") then
			ni.drtracker.wipe(destGUID)
		end
	elseif event == "PLAYER_LEAVING_WORLD" then
		ni.drtracker.wipeall()
	end
end

ni.frames.drtracker_OnUpdate = function(self, elapsed)
	local throttle = 30 / GetFramerate()

	self.st = elapsed + (self.st or 0)
	if self.st > throttle then
		self.st = 0
		ni.drtracker.updateresettime()
	end
end
