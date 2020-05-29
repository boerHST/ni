local queue = {
	"fish"
}
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
									local result = ni.memory.read("byte", ptr, 0x0CC)
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
			ni.spell.delaycast("Fishing", nil, 1.5);
		end
	end,
}
ni.bootstrap.rotation("Fishing", queue, abilities);