ni.bootstrap = {
	rotation = function(profile, queue, abilities, data)
		data = true and data or {}
		ni.debug.log("Loaded " .. profile)
		rawset(ni.rotation.profile, profile, ni.bootstrap.start(queue, abilities, data))
	end,
	start = function(queue, abilities, data)
		return {
			loaded = false,
			execute = function()
				if not ni.rotation[ni.vars.profiles.active].loaded then
					ni.utils.loadfiles(data)
					ni.rotation[ni.vars.profiles.active].loaded = true
				end

				if type(queue) == "function" then
					queue = queue()
				end

				for i = 1, #queue do
					local abilityinqueue = queue[i]
					if abilities[abilityinqueue]() then
						break
					end
				end
			end,
			unload = function()
				if ni.rotation.profile[ni.vars.profiles.active].loaded then
					table.wipe(ni.data)
					ni.rotation.profile[ni.vars.profiles.active].loaded = false
				end
			end
		}
	end
}
