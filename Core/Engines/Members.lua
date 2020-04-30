ni.memberssetup = {}
ni.memberssetup.cache = {}
ni.memberssetup.__index = {
	unit = "noob",
	name = "noob",
	class = "noob",
	guid = 0,
	shortguid = 0,
	role = "NOOB",
	range = false,
	dispel = false,
	hp = 100,
	threat = 0,
	target = "noobtarget",
	istank = false
}
ni.memberssetup.cache.__index = {
	guid = 0,
	name = "Unknown",
	type = 0
}
local membersmt = {}
setmetatable(ni.members, membersmt)
membersmt.__call = function(_, ...)
	local group = GetNumRaidMembers() > 0 and "raid" or "party"
	local groupsize = group == "raid" and GetNumRaidMembers() or GetNumPartyMembers()
	if group == "party" then
		tinsert(ni.members, ni.memberssetup:create("player"))
	end
	for i = 1, groupsize do
		local groupunit = group .. i
		local groupmember = ni.memberssetup:create(groupunit)
		if groupmember then
			tinsert(ni.members, groupmember)
		end
	end
end
membersmt.__index = {
	name = "members",
	author = "bubba"
}

function ni.memberssetup:create(unit)
	if ni.memberssetup.cache[ni.unit.shortguid(unit)] then
		return false
	end
	local o = {}
	setmetatable(o, ni.memberssetup)
	if unit and type(unit) == "string" then
		o.unit = unit
	end
	function o:calculateistank()
		local result = false
		if select(2, UnitClass(o.unit)) == "WARRIOR" and ni.unit.hasaura(o.guid, 71) then
			result = true
		end
		if select(2, UnitClass(o.unit)) == "DRUID" and ni.unit.hasbuff(o.unit, 9634) then
			result = true
		end
		if ni.unit.hasaura(o.guid, 57340) then
			result = true
		end
		return result
	end
	function o:hasdebufftype(str)
		return ni.unit.hasdebufftype(o.guid, str)
	end
	function o:hasbufftype(str)
		return ni.unit.hasbufftype(o.guid, str)
	end
	function o:candispel()
		return ni.healing.candispel(o.unit)
	end
	function o:calculatehp()
		local hp = ni.unit.hp(o.unit)
		local hpraw = ni.unit.hpraw(o.unit)

		if o.istank then
			hp = hp - 5
		end
		if UnitIsDeadOrGhost(o.unit) == 1 then
			hp = 250
		end
		if o.dispel then
			hp = hp - 2
		end
		for i = 1, #ni.tables.cantheal do
			if ni.unit.hasdebuff(o.unit, ni.tables.cantheal[i]) then
				hp = 100
				hpraw = UnitHealthMax(o.unit)
			end
		end
		return hp, hpraw
	end
	function o:inrange()
		local range = false

		if ni.unit.exists(o.guid) and ni.spell.los(o.guid) then
			local dist = ni.player.distance(o.guid)
			if (dist ~= nil and dist < 40) then
				range = true
			else
				range = false
			end
		end
		return range
	end
	function o:updatemember()
		o.name = UnitName(o.unit)
		o.class = select(2, UnitClass(o.unit))
		o.guid = UnitGUID(o.unit)
		o.shortguid = ni.unit.shortguid(o.unit)
		o.range = o:inrange()
		o.dispel = o:candispel()
		o.hp = o:calculatehp()
		o.threat = ni.unit.threat(o.unit)
		o.target = tostring(o.unit) .. "target"
		o.istank = o:calculateistank()
		ni.memberssetup.cache[ni.unit.shortguid(o.unit)] = o
	end
	ni.memberssetup.cache[ni.unit.shortguid(o.unit)] = o
	return o
end

ni.memberssetup.set = function()
	function ni.members:updatemembers()
		for i = 1, #ni.members do
			ni.members[i]:updatemember()
		end

		table.sort(
			ni.members,
			function(x, y)
				if x.range and y.range then
					return x.hp < y.hp
				elseif x.range then
					return true
				elseif y.range then
					return false
				else
					return x.hp < y.hp
				end
			end
		)
	end
	ni.members()
end

ni.memberssetup.set()
