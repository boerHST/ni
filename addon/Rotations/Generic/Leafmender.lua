local queue = {
	"target"
}
local items = {
	settingsfile = "Leafmender_Farm.xml",
	{ type = "title", text = "Leafmender Farming" },
	{ type = "separator" },
	{ type = "title", text = "Spell ID to use for farming:" },
	{ type = "input", value = "20271", key = "Spell" },
	{ type = "entry", text = "Loot on death", enabled = true, key = "Loot" },
	{ type = "entry", text = "Anti-AFK", enabled = true, key = "AntiAFK" },
}
local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
         and v.key ~= nil
         and v.key == name then
            return v.value, v.enabled
        end
        if v.type == "dropdown"
         and v.key ~= nil
         and v.key == name then
            for k2, v2 in pairs(v.menu) do
                if v2.selected then
                    return v2.value
                end
            end
        end
        if v.type == "input"
         and v.key ~= nil
         and v.key == name then
            return v.value
        end
    end
end;
local function CombatEventCatcher(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subevent, _, _, _, _, _, guid = ...;
		if subevent == "UNIT_DIED" then
			if (UnitName(guid)) == "Leafmender" then
				local enabled = select(2, GetSetting("Loot"));
				if enabled then
					ni.player.interact(guid);
				end
			end
		end
	end
end
local function OnLoad()
	ni.GUI.AddFrame("Leafmender", items);
	ni.combatlog.registerhandler("Leafmender", CombatEventCatcher);
end
local function OnUnload()
	ni.GUI.DestroyFrame("Leafmender");
	ni.combatlog.unregisterhandler("Leafmender");
end
local abilities = {
	["target"] = function()
		local spell = tonumber(GetSetting("Spell"));
		local antiafk = select(2, GetSetting("AntiAFK"));
		if antiafk then
			ni.functions.resetlasthardwareaction()
		end
		if spell ~= nil then
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and type(v) == "table" then
					if v.name == "Leafmender" then
						if UnitIsDead(v.guid) == nil and UnitAffectingCombat(v.guid) then
							if ni.spell.cd(spell) == 0 then
								ni.spell.cast(spell, v.guid);
							end
							return true;
						end
					end
				end
			end
		end
	end,
}
ni.bootstrap.profile("Leafmender", queue, abilities, OnLoad, OnUnload);