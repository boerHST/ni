local UnitName, GetTime, CreateFrame = UnitName, GetTime, CreateFrame

local maul, cleave, heroicstrike, runestrike, raptorstrike = GetSpellInfo(6807), GetSpellInfo(845), GetSpellInfo(78), GetSpellInfo(56815), GetSpellInfo(2973);

local function isspelltoignore(spellname)
	if spellname == maul
	 or spellname == cleave
	 or spellname == heroicstrike
	 or spellname == raptorstrike
	 or spellname == runestrike then
		return true;
	end
	return false;
end

ni.frames.combatlog = CreateFrame("Frame")
ni.frames.combatlog:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_SENT")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_STOP")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_FAILED")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
ni.frames.combatlog:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
ni.frames.combatlog:RegisterEvent("PLAYER_REGEN_ENABLED")
ni.frames.combatlog:RegisterEvent("PLAYER_REGEN_DISABLED")
ni.frames.combatlog_OnEvent = function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		ni.vars.combat.started = true
		ni.vars.combat.time = GetTime()
		ni.vars.combat.ended = 0
	end
	if event == "PLAYER_REGEN_ENABLED" then
		ni.vars.combat.started = false
		ni.vars.combat.time = 0
		ni.vars.combat.ended = GetTime()
	end
	if (event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_CHANNEL_START") and ni.vars.combat.casting == false then
		local unit, spell = ...
		if unit == "player" and not isspelltoignore(spell) then
			ni.vars.combat.casting = true
		end
	end
	if (event == "UNIT_SPELLCAST_SUCCEEDED"
	 or event == "UNIT_SPELLCAST_FAILED"
	 or event == "UNIT_SPELLCAST_FAILED_QUIET"
	 or event == "UNIT_SPELLCAST_INTERRUPTED"
	 or event == "UNIT_SPELLCAST_CHANNEL_STOP"
	 or event == "UNIT_SPELLCAST_STOP")
	 and ni.vars.combat.casting == true then
		local unit, spell = ...
		if unit == "player" and not isspelltoignore(spell) then
			if ni.vars.combat.casting then
				ni.vars.combat.casting = false
			end
		end
	end
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subevent, _, source, _, _, dest, _, spellID, spellName = ...
		if source == UnitName("player") then
			if subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_CAST_FAILED" and not isspelltoignore(spellName) then
				if ni.vars.combat.casting then
					ni.vars.combat.casting = false
				end
			end
		end
	end
end
