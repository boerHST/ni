local queue = {
	"fish"
}
local offset;
if ni.vars.build == 40300 then
	offset = 0xD4;
elseif ni.vars.build > 40300 then
	offset = 0xCC;
else
	offset = 0xBC;
end
local functionsent = 0;
local abilities = {
	["fish"] = function()
		if ni.player.islooting() then
			return
		end
		if UnitChannelInfo("player") then
			if GetTime() - functionsent > 1 then
				local playerguid = UnitGUID("player");
				for k, v in pairs(ni.objects) do
					if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
						if v.name == "Fishing Bobber" then
							local creator = v:creator();
							if tonumber(creator) == tonumber(playerguid) then
								local ptr = ni.memory.objectpointer(v.guid);
								if ptr ~= nil then
									local result = ni.memory.read("byte", ptr, offset)
									if result == 1 then
										ni.player.interact(v.guid);
										functionsent = GetTime();
										return true;
									end
								end
							end
						end
					end
				end
			end
		else
			for k, v in pairs(ni.objects) do
				if type(v) ~= "function" and v.name ~= nil and string.match(v.name, "School") then
					local dist = ni.player.distance(k);
					if dist ~= nil and dist < 20 then
						ni.player.lookat(k);
						break;
					end
				end
			end
			ni.spell.delaycast("Fishing", nil, 1.5);
			ni.utils.resetlasthardwareaction();
		end
	end,
}
ni.bootstrap.rotation("Fishing", queue, abilities);