ni.bootstrap = {
	rotation = function(class, profile, queue, abilities)
		rawset(ni[class].rotations, profile, ni.bootstrap.start(queue, abilities))
		ni.bootstrap.pre(profile)
	end,
	pre = function(profile)
		ni.debug.log(profile .. " Loaded")
	end,
	start = function(queue, abilities)
		return {
			execute = function()
				if type(queue) ~= "function" then
					queue = queue()
				end

				for i = 1, #queue do
					local abilityinqueue = queue[i]
					if abilities[abilityinqueue]() then
						break
					end
				end
			end
		}
	end
}
