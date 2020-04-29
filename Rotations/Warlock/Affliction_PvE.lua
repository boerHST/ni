if ni.utils.loadfile("Rotations\\Data\\brajevicm\\Warlock.lua") then
	local abilities = {
		["Print Hello"] = function()
			ni.debug.log(ni.data.brajevicm.warlock.hello)
		end
	}

	local queue = {
		"Print Hello"
	}

	local callback = function()
		return queue
	end

	ni.bootstrap.rotation("Affliction_PvE", queue, abilities)
	ni.bootstrap.rotation("Affliction_PvE", callback, abilities)
end
