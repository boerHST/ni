ni.stopcastingtracker = {
	stoptime = 0,
	shouldstop = function(spell, t)
		t = true and t or "target"
		local mycasttime = ni.spell.casttime(spell)
		local bosscast, bosscastend, mycastend

		if UnitCastingInfo("boss1") then
			bosscast, _, _, _, bosscastend = UnitCastingInfo("boss1")
		else
			return false
		end

		if UnitCastingInfo("player") then
			mycastend = select(5, UnitCastingInfo("player"))
		else
			mycastend = mycasttime
		end

		for i = 1, #ni.tables.stopcasting.continue do
			local buff = ni.tables.stopcasting.continue[i]

			if ni.unit.hasbuff(buff) and (select(6, ni.unit.hasbuff(buff)) * 1000) + 50 > bosscastend then
				return false
			end
		end

		if
			not ni.player.iscasting() and not ni.player.ischanneling() and mycasttime and ni.stopcastingtracker.stoptime and
				mycasttime > bosscastend
		 then
			return true
		end

		for i = 1, #ni.tables.stopcasting.stop do
			local casting = ni.tables.stopcasting.stop[i]

			if bosscast == select(1, GetSpellInfo(casting)) then
				ni.stopcastingtracker.stoptime = bosscastend

				if mycastend ~= nil then
					if bosscastend < mycasttime then
						return true
					end
				end
			end
		end
	end
}
