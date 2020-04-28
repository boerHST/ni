ni.bootstrap = {
	rotation = function(queue, abilities)
		return {
			execute = function()
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
