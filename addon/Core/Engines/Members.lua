local GetNumRaidMembers, GetNumPartyMembers, tinsert, UnitClass, UnitIsDeadOrGhost, UnitHealthMax, UnitName, UnitGUID =
	GetNumRaidMembers,
	GetNumPartyMembers,
	tinsert,
	UnitClass,
	UnitIsDeadOrGhost,
	UnitHealthMax,
	UnitName,
	UnitGUID

local memberssetup = {}
memberssetup.cache = {}
memberssetup.__index = {
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
memberssetup.cache.__index = {
	guid = 0,
	name = "Unknown",
	type = 0
}
local membersmt = {}
setmetatable(ni.members, membersmt)
membersmt.__call = function(_, ...)
	if ni.vars.build == 50400 then
		local group = IsInRaid() and "raid" or "party"
		local groupSize = IsInRaid() and GetNumGroupMembers() or GetNumGroupMembers() - 1
		if group == "party" then
			tinsert(ni.members, memberssetup:create("player"))
		end
		for i = 1, groupSize do
			local groupUnit = group .. i
			local groupMember = memberssetup:create(groupUnit)
			if groupMember then
				tinsert(ni.members, groupMember)
			end
		end
	else
		local group = GetNumRaidMembers() > 0 and "raid" or "party"
		local groupsize = group == "raid" and GetNumRaidMembers() or GetNumPartyMembers()
		if group == "party" then
			tinsert(ni.members, memberssetup:create("player"))
		end
		for i = 1, groupsize do
			local groupunit = group .. i
			local groupmember = memberssetup:create(groupunit)
			if groupmember then
				tinsert(ni.members, groupmember)
			end
		end
	end
end
membersmt.__index = {
	name = "members",
	author = "bubba"
}

function memberssetup:create(unit)
	if memberssetup.cache[ni.unit.shortguid(unit)] then
		return false
	end
	local o = {}
	setmetatable(o, memberssetup)
	if unit and type(unit) == "string" then
		o.unit = unit
	end
	function o:calculateistank()
		local result = false
		if select(2, UnitClass(o.unit)) == "WARRIOR" and ni.unit.aura(o.guid, 71) then
			result = true
		end
		if select(2, UnitClass(o.unit)) == "DRUID" and ni.unit.buff(o.unit, 9634) then
			result = true
		end
		if ni.unit.aura(o.guid, 57340) then
			result = true
		end
		return result
	end
	function o:debufftype(str)
		return ni.unit.debufftype(o.guid, str)
	end
	function o:bufftype(str)
		return ni.unit.bufftype(o.guid, str)
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
			if ni.unit.debuff(o.unit, ni.tables.cantheal[i]) then
				hp = 100
				hpraw = UnitHealthMax(o.unit)
			end
		end
		return hp, hpraw
	end
	function o:inrange()
		local range = false

		if ni.unit.exists(o.guid) and ni.player.los(o.guid) then
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
		memberssetup.cache[ni.unit.shortguid(o.unit)] = o
	end
	memberssetup.cache[ni.unit.shortguid(o.unit)] = o
	return o
end
memberssetup.set = function()
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
	function ni.members.reset()
		table.wipe(ni.members)
		table.wipe(memberssetup.cache)
		memberssetup.set()
	end
	function ni.members.below(percent)
		local total = 0;
		for i = 1, #ni.members do
			if ni.members[i].hp < percent then
				total = total + 1;
			end
		end
	end
	function ni.members.average()
		local count = #ni.members;
		local average = 0;
		for i = 1, count do
			average = average + ni.members[i].hp;
		end
		return average/count;
	end
	function ni.members.averageof(count)
		local members = count;
		local average = 0;
		if #ni.members < members then
			for i = members, 0, -1 do
				if #ni.members >= i then
					members = i;
					break;
				end
			end
		end
		for i = 1, members do
			average = average + ni.members[i].hp;
		end
		return average/members;
	end
	ni.members()
end
memberssetup.set()
