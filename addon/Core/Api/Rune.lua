local GetRuneCooldown, GetRuneType, GetTime = GetRuneCooldown, GetRuneType, GetTime

ni.rune = {
	available = function()
		local runesavailable = 0
		for i = 1, 6 do
			local _, _, ready = GetRuneCooldown(i)
			if ready == true then
				runesavailable = runesavailable + 1
			end
		end

		return runesavailable
	end,
	cd = function(rune)
		local runesoncd = 0
		local runesoffcd = 0

		for i = 1, 6 do
			if GetRuneType(i) == rune and select(3, GetRuneCooldown(i)) == false then
				runesoncd = runesoncd + 1
			elseif GetRuneType(i) == rune and select(3, GetRuneCooldown(i)) == true then
				runesoffcd = runesoffcd + 1
			end
		end
		return runesoncd, runesoffcd
	end,
	deathrunecd = function()
		return ni.rune.cd(4)
	end,
	frostrunecd = function()
		return ni.rune.cd(2)
	end,
	unholyrunecd = function()
		return ni.rune.cd(3)
	end,
	bloodrunecd = function()
		return ni.rune.cd(1)
	end
}
