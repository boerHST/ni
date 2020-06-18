ni.bootstrap = {
	rotation = function(profile, queue, abilities, data, GUI)
		GUI = true and GUI or {};
		data = true and data or {}
		ni.debug.log("Loaded " .. profile)
		rawset(ni.rotation.profile, profile, ni.bootstrap.start(queue, abilities, data, GUI))
	end,
	start = function(queue, abilities, data, GUI)
		return {
			loaded = false,
			execute = function()
				if not ni.rotation.profile[ni.vars.profiles.active].loaded then
					if GUI ~= nil and #GUI > 0 then
						ni.GUI.AddFrame(GUI[1], GUI[2]);
					end
					if data ~= nil and #data > 0 then
						if ni.utils.loaddatafiles(data) then
							ni.rotation.profile[ni.vars.profiles.active].loaded = true
						end
					else
						ni.rotation.profile[ni.vars.profiles.active].loaded = true
					end
				end
				local temp_queue;
				if type(queue) == "function" then
					temp_queue = queue()
				else
					temp_queue = queue;
				end
				for i = 1, #temp_queue do
					local abilityinqueue = temp_queue[i]
					if abilities[abilityinqueue]() then
						break
					end
				end
			end,
			unload = function()
				if ni.rotation.profile[ni.rotation.lastprofile].loaded then
					table.wipe(ni.data)
					if GUI ~= nil and #GUI > 0 then
						ni.GUI.DestroyFrame(GUI[1]);
					end
					ni.rotation.profile[ni.rotation.lastprofile].loaded = false
				end
			end
		}
	end
}
