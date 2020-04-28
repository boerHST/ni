if ni.utils.loadfile("Rotations\\Data\\brajevicm\\Warlock.lua") then
	local hello = hello -- Loaded from file above

	local abilities = {
		["Print Hello"] = function()
			ni.debug.log(hello)
		end
	}

	local queue = {
		"Print Hello"
	}

	local callback = function()
		return queue
	end

	ni.bootstrap.rotation("WARLOCK", "Affliction_PvE", queue, abilities)
	ni.bootstrap.rotation("WARLOCK", "Affliction_PvE", callback, abilities)
end
