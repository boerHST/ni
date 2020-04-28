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

	rawset(ni["WARLOCK"].rotations, "Affliction_PvE", ni.bootstrap.rotation(queue, abilities))
	ni.debug.log("Affliction Loaded")
end
