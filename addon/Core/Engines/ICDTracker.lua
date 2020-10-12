ni.icdtracker = {
	timers = {},
	set = function(item, icd)
		ni.icdtracker.timers[item] = {
			icd = icd,
			time = 0
		}
	end,
	get = function(item)
		if ni.icdtracker.timers[item] then
			local remaining = ni.icdtracker.timers[item].time - GetTime()

			if remaining < 1 then
				return 0
			end

			return remaining
		end

		return -1
	end
}
