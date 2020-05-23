local settings = {
	main = {
		emist = 60,
		manatealimit = 2,
		manatea = 90,
		rmist = 95,
		rmisttank = 99,
		smist = 71,
		smist4chi = 95,
		surmistinst = 70,
		surmist = 40,
		tftsurmist = 20,
		tftrmist = 6,
		lifecocoon = 20,
		sck = 70,
		scklimit = 3,
		lowmana = 20,
		detox = 60
	},
	master = {
		upliftcount = 3,
		uplift = 90,
		tfteauplift = 4,
		chiburstlimit = 3,
		chiburst = 80,
		zenspherelimit = 1,
		zensphere = 85,
		chiwavelimit = 2,
		chiwave = 85,
		revivallimit = 4,
		revival = 60
	},
	party = {
		upliftcount = 3,
		uplift = 90,
		tfteauplift = 4,
		chiburstlimit = 3,
		chiburst = 80,
		zenspherelimit = 1,
		zensphere = 85,
		chiwavelimit = 2,
		chiwave = 85,
		revivallimit = 4,
		revival = 60
	},
	raid10 = {
		upliftcount = 3,
		uplift = 85,
		tfteauplift = 4,
		chiburstlimit = 4,
		chiburst = 85,
		zenspherelimit = 2,
		zensphere = 85,
		chiwavelimit = 3,
		chiwave = 85,
		revivallimit = 8,
		revival = 60
	},
	raid25 = {
		upliftcount = 3,
		uplift = 90,
		tfteauplift = 4,
		chiburstlimit = 5,
		chiburst = 85,
		zenspherelimit = 2,
		zensphere = 85,
		chiwavelimit = 3,
		chiwave = 85,
		revivallimit = 16,
		revival = 60
	},
	current = nil,
};
local mainqueue = {
	"add to members",
	"pause",
	"stopcasting",
	"Stance Of The Wise Serpent",
	"Legacy Of The Emperor",
	"Jade Serpent Statue",
	"Self Survival",
	"Life Cocoon",
	"Revival",
	"Mana Tea",
	"Detox Mouseover",
	"Renewing Mist",
	"Chi Burst",
	"Zen Sphere",
	"Chi Wave",
	"Uplift",
	"Spinning Crane Kick",
	"Surging Mist",
	"Enveloping Mist",
	"Soothing Mist",
	"Expel Harm",
	"DPS: SM",
	"DPS: RM",
	"DPS: BoK",
	"DPS: TP",
	"DPS: Jab",
};
local raidqueue = {
	"add to members",
	"pause",
	"stopcasting",
	"Stance Of The Wise Serpent",
	"Legacy Of The Emperor",
	"Jade Serpent Statue",
	"Self Survival",
	"Life Cocoon",
	"Revival",
	"Mana Tea",
	"Tsulong Heal",
	"Detox Mouseover",
	"Renewing Mist",
	"Chi Burst",
	"Zen Sphere",
	"Chi Wave",
	"Uplift",
	"Spinning Crane Kick",
	"Surging Mist",
	"Enveloping Mist",
	"Soothing Mist",
	"Expel Harm",
	"DPS: SM",
	"DPS: RM",
	"DPS: BoK",
	"DPS: TP",
	"DPS: Jab",
};
local IsInInstance,
		GetInstanceInfo,
		UnitIsDeadOrGhost,
		UnitCastingInfo,
		UnitAffectingCombat,
		SpellIsTargeting,
		UnitChannelInfo,
		GetSpellInfo,
		UnitGetIncomingHeals,
		UnitHealth,
		UnitHealthMax =
		IsInInstance,
		GetInstanceInfo,
		UnitIsDeadOrGhost,
		UnitCastingInfo,
		UnitAffectingCombat,
		SpellIsTargeting,
		UnitChannelInfo,
		GetSpellInfo,
		UnitGetIncomingHeals,
		UnitHealth,
		UnitHealthMax;

local temptable = { };
local customtable = { };
local function SortByUnits(x, y)
	return x.unitsclose > y.unitsclose;
end
local function SortByHP(x, y)
	return x.hp < y.hp
end
local function GetTableForBestUnit(health, distance, unitsclose, buff)
	table.wipe(customtable);
	for i = 1, #ni.members do
		if ni.members[i].hp <= health
		 and ni.members[i].range
		 and (buff ~= nil 
		 and not ni.unit.buff(ni.members[i].unit, buff, "player")) then
			table.wipe(temptable);
			if buff ~= nil then
				temptable = ni.members.inrangewithoutbuff(ni.members[i].unit, distance, buff, "player");
				for k, v in ipairs(temptable) do
					if v and v.hp > health then
						tremove(temptable, k);
					end
				end
			else
				temptable = ni.members.inrangebelow(ni.members[i].unit, distannce, health);				
			end
			if #temptable >= unitsclose then
				tinsert(customtable, { unit = ni.members[i].unit, hp = ni.members[i].hp, unitsclose = #temptable });
			end
		end
	end
	if #customtable > 0 then
		table.sort(customtable, SortByHP)
	end
end
local function CalculateStopHealing(tar)
	local myincheal = UnitGetIncomingHeals(tar, "player") or 0;
	local allincheal = UnitGetIncomingHeals(tar) or 0;
	local overheal = 0;
	if myincheal >= allincheal then
		overheal = 0;
	else
		overheal = allincheal - myincheal;
	end
	local curshield = UnitHealth(tar);
	if ni.player.debuff(142861) then
		curshield = select(15, ni.unit.debuff(tar, 142863)) or select(15, ni.unit.debuff(tar, 142864)) or select(15, ni.unit.debuff(tar, 142865)) or (UnitHealthMax(tar) / 2) or 400000;
		overheal = 0;
	end
	local overhealth = 100 * (curshield + overheal) / UnitHealthMax(tar);
	if overhealth and overheal then
		return overhealth, overheal;
	else
		return 0, 0;
	end
end
local function available(spell)
	return ni.spell.available(spell, true);
end
local soothingmist = GetSpellInfo(115175);
local surgingmist = GetSpellInfo(116694);
local envelopingmist = GetSpellInfo(124682);
local zenmeditation = GetSpellInfo(131523);
local cracklingjadelightning = GetSpellInfo(117952);
local jab = GetSpellInfo(115693);
local blackoutkick = GetSpellInfo(100784);
local tigerpalm = GetSpellInfo(100787);

local abilities = {
	["add to members"] = function()
		if GetCurrentKeyBoardFocus() then
			return;
		end
		if not IsRightShiftKeyDown() and ni.functions.keypressed(0x52) then
			if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
				ni.members.addcustom(UnitGUID("mouseover"));
				return true;
			end
		elseif IsRightShiftKeyDown() and ni.functions.keypressed(0x52) then
			if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
				ni.members.removecustom(UnitGUID("mouseover"));
				return true;
			end
		end
	end,
	["pause"] = function()
		if UnitIsDeadOrGhost("player")
		 or IsMounted()
		 or ni.player.buff(104269) then
			return true;
		end
	end,
	["stopcasting"] = function()
		if SpellIsTargeting() then
			ni.spell.stopcasting();
		elseif UnitChannelInfo("player") == soothingmist
		 and ni.player.powerraw("chi") >= 4 then
			for i = 1, #ni.members do
				if ni.unit.buff(ni.members[i].unit, 115175, "player")
				 and (IsSpellInRange(soothingmist, ni.members[i].unit) ~= 1
				 or CalculateStopHealing(ni.members[i].unit) > settings.main.smist4chi) then
					ni.spell.stopcasting();
					return true;
				end
			end
		end
		local curcast = UnitCastingInfo("player");
		if curcast == surgingmist then
			ni.spell.stopcasting();
			return true;
		elseif curcast == envelopingmist then
			ni.spell.stopcasting();
			return true;
		end
	end,
	["Stance Of The Wise Serpent"] = function()
		if GetShapeshiftForm() ~= 1
		 and not UnitCastingInfo("player") then
			ni.spell.cast(115070);
		end
	end,
	["Legacy Of The Emperor"] = function()
		if not ni.player.buff(1126)
		 and not ni.player.buff(20217)
		 and not ni.player.buff(90363)
		 and not ni.player.buff(115921)
		 and ni.spell.available(115921)
		 and not UnitCastingInfo("player") then
				ni.spell.cast(115921, "player");
				return true;
		 end
	end,
	["Jade Serpent Statue"] = function()
		if not GetCurrentKeyBoardFocus() and ni.functions.keypressed(0x47) then
			if not UnitChannelInfo("player")
			 and not UnitCastingInfo("player")
			 and available(115313) then
				ni.spell.castat(115313, "mouse");
				return true;
			end
		end
	end,
	["Self Survival"] = function()
		if ni.player.hp() <= 20
		 and UnitAffectingCombat("player") then
			local curchannel = UnitChannelInfo("player");
			local iscasting = UnitCastingInfo("player");
			if GetItemCount(5512, false, true) > 0
			 and ni.player.itemcd(5512) == 0
			 and curchannel ~= zenmeditation then
				if iscasting then
					ni.spell.stopcasting();
				end
				ni.player.useitem(5512);
				return true;
			elseif available(122278)
			 and curchannel ~= zenmeditation
			 and select(2, GetTalentRowSelectionInfo(5)) == 14 then
				if iscasting then
					ni.spell.stopcasting();
				end
				ni.spell.cast(122278);
				return true;
			elseif available(115203)
			 and curchannel ~= zenmeditation
			 and not ni.player.buff(122278) then
				if iscasting then
					ni.spell.stopcasting();
				end
				ni.spell.cast(115203);
				return true;
			end
		end
	end,
	["Life Cocoon"] = function()
		if available(116849)
		 and UnitChannelInfo("player") ~= zenmeditation
		 and UnitAffectingCombat("player")
		 and ni.members[1].hp < settings.main.lifecocoon
		 and ni.members[1].threat == 3
		 and ni.spell.valid(ni.members[1].unit, 116849, false, true, true) then
			if UnitCastingInfo("player") then
				ni.spell.stopcasting();
			end
			ni.spell.cast(116849, ni.members[1].unit);
			return true;
		end
	end,
	["Revival"] = function()
		if available(115310)
		 and UnitChannelInfo("player") ~= zenmeditation
		 and UnitAffectingCombat("player") then
			local count = settings.current.revivallimit;
			if settings.current.revivallimit > #ni.members then
				count = #ni.members
			end
			if #ni.members.inrangebelow(settings.current.revival) >= settings.current.revivallimit then
			--and ni.members.averageof(settings.current.revivallimit) <= settings.current.revival then
				if UnitCastingInfo("player") then
					ni.spell.stopcasting();
				end
				ni.spell.cast(115310);
				return true;
			end
		end
	end,
	["Mana Tea"] = function()
		local curchannel = UnitChannelInfo("player");
		if available(115294)
		 and not ni.player.buff(101546)
		 and curchannel ~= zenmeditation
		 and curchannel ~= cracklingjadelightning
		 and not UnitCastingInfo("player") then
			local manatea, _, _, count = ni.player.buff(115867);
			if manatea
			 and ((count >= settings.main.manatealimit
			 and ni.player.power("mana") <= settings.main.manatea)
			 or ni.player.buff(64904)
			 or ni.player.power("mana") <= settings.main.lowmana) then
				ni.spell.cast(115294, "player");
				return true;
			end
		end
	end,
	["Tsulong Heal"] = function()

	end,
	["Detox Mouseover"] = function()
		if available(115450) then
			local curchannel = UnitChannelInfo("player");
			if UnitExists("mouseover")
			 and not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and ni.spell.valid("mouseover", 115450, false, true, true)
			 and ni.healing.candispel("mouseover") then 
				ni.spell.cast(115450, "mouseover");
				return true;
			end
		end
	end,
	["Renewing Mist"] = function()
		if available(115151) then
			local curchannel = UnitChannelInfo("player");
		 	if not ni.player.buff(101546)
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning then
				GetTableForBestUnit(settings.main.rmisttank, 40, 2, 115151);
				if #customtable > 0 then
					if customtable[1].unitsclose >= 2
					 and ni.spell.valid(customtable[1].unit, 115151, false, true, true) then
						if UnitThreatSituation(customtable[1].unit) == 3
						 or customtable[1].hp <= settings.main.rmist then
							ni.spell.cast(115151, customtable[1].unit);
							return true;
						end
					end
				end
				--for i = 1, #ni.members do
				--	if ni.members[i].hp <= settings.main.rmist
				--	 and not ni.unit.buff(ni.members[i].unit, 115151, "player")
				--	 and ni.spell.valid(ni.members[i].unit, 115151, false, true, true) then
				--		ni.spell.cast(115151, ni.members[i].unit);
				--		return true;
				--	end
				--end
			end
		end
	end,
	["Chi Burst"] = function()
		
	end,
	["Zen Sphere"] = function()
		
	end,
	["Chi Wave"] = function()
		if select(2, GetTalentRowSelectionInfo(2)) == 4 and available(115098) then
			local curchannel = UnitChannelInfo("player");
			if not ni.player.buff(101546)
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and UnitAffectingCombat("player")
			 and ni.members.averageof(settings.current.chiwavelimit) <= settings.current.chiwave then
				for i = 1, 4 do
					local boss = "boss"..i;
					if UnitExists(boss) and ni.unit.shortguid(boss) == 60708 then
						for i = 1, #ni.members do
							if ni.unit.debuff(ni.members[i].unit, 117708) then
								return false;
							end
						end
					end
				end
				GetTableForBestUnit(settings.current.chiwave, 20, settings.current.chiwavelimit);
				if #customtable > 0 then
					if ni.spell.valid(customtable[1].unit, 115098, false, true, true) then
						ni.spell.cast(115098, customtable[1].unit);
						return true;
					end
				end
			end
		end
	end,
	["Uplift"] = function()
		local curchannel = UnitChannelInfo("player");
		if available(116670)
		 and not ni.player.buff(101546)
		 and not UnitCastingInfo("player")
		 and curchannel ~= zenmeditation
		 and curchannel ~= cracklingjadelightning then
			local upliftcount = 0;
			local rmcount = 0;
			for i = 1, #ni.members do
				if ni.unit.buff(ni.members[i].unit, 115151, "player") then
					rmcount = rmcount + 1;
					if ni.members[i].hp <= settings.current.uplift then
						upliftcount = upliftcount + 1;
					end
				end
			end
			local chi = ni.player.powerraw("chi");
			if chi >= 2 then
				if (upliftcount >= settings.current.upliftcount
				 and (chi >= 2 and ni.player.power("mana") < settings.main.lowmana))
				 or (chi >= 4
				 and (upliftcount >= (settings.current.upliftcount -1))) then
					if available(116680)
					 and not ni.player.buff(116680)
					 and chi >= 3
					 and ((upliftcount >= settings.current.tfteauplift)
					 or (rmcount >= settings.main.tftrmist)) then
						ni.spell.cast(116680);
					end
					ni.spell.cast(116670);
					return true;
				end
			end
		end
	end,
	["Spinning Crane Kick"] = function()
		
	end,
	["Surging Mist"] = function()
		local curchannel = UnitChannelInfo("player");
		if available(116694)
		 and not ni.player.buff(101546)
		 and not UnitCastingInfo("player")
		 and curchannel ~= zenmeditation
		 and curchannel ~= cracklingjadelightning
		 and ni.spell.valid(ni.members[1].unit, 116694, false, true, true) then
			local vm, _, _, count = ni.player.buff(118674);
			if ni.members[1].hp < settings.main.surmistinst
			 and vm and count == 5 then
				if available(116680)
				 and not ni.player.buff(116680)
				 and ni.player.powerraw("chi") >= 1
				 and ni.members[1].hp <= settings.main.tftsurmist then
					ni.spell.cast(116680);
				end
				ni.spell.cast(116694, ni.members[1].unit);
				return true;
			end
			if ni.members[1].hp < settings.main.surmist
			 and ni.player.power("mana") > settings.main.lowmana - 5 then
				if curchannel == soothingmist
				 and ni.unit.buff(ni.members[1].unit, 115175) then
					if available(116680)
					 and not ni.player.buff(116680)
					 and ni.player.powerraw("chi") >= 1
					 and ni.members[1].hp <= settings.main.tftsurmist then
					  ni.spell.cast(116680);
				  end
				  ni.spell.cast(116694, ni.members[1].unit);
				  return true;
				end
			end
		end
	end,
	["Enveloping Mist"] = function()
		local curchannel = UnitChannelInfo("player");
		if available(124682)
		 and ni.members[1].hp < settings.main.emist
		 and not ni.player.buff(101546)
		 and not UnitCastingInfo("player")
		 and curchannel ~= zenmeditation
		 and curchannel ~= cracklingjadelightning
		 and curchannel == soothingmist
		 and ni.spell.valid(ni.members[1].unit, 124682, false, true, true)
		 and ni.unit.buff(ni.members[1].unit, 115175, "player")
		 and not ni.unit.buff(ni.members[1].unit, 124682, "player") then
			local chi = ni.player.powerraw("chi");
			if chi >= 3 then
				ni.spell.cast(124682, ni.members[1].unit);
				return true;
			elseif chi == 0
			 and select(2, GetTalentRowSelectionInfo(3)) == 9
			 and ni.spell.cd(115399) == 0 then
				ni.spell.cast(115399);
				ni.spell.cast(124682, ni.members[1].unit);
				return true;
			end
		end
	end,
	["Soothing Mist"] = function()
		if ni.spell.valid("target", jab, true, true) then
			return false;
		end
		local curchannel = UnitChannelInfo("player");
		if available(115175)
		 and not ni.player.buff(101546)
		 and not UnitCastingInfo("player")
		 and curchannel ~= zenmeditation
		 and curchannel ~= cracklingjadelightning
		 and not ni.player.ismoving()
		 and not ni.player.buff(131523)
		 and not ni.members[1]:buff(115175, "player")
		 and ni.spell.valid(ni.members[1].unit, 115175, false, true, true) then
			local chi = ni.player.powerraw("chi");
			if ni.members[1].hp <= settings.main.smist 
			 and chi >= 4 then
				ni.spell.cast(soothingmist, ni.members[1].unit);
				return true;
			elseif ni.members[1].hp <= settings.main.smist4chi
			 and ni.player.power("mana") >= 15
			 and chi < 4 then
				ni.spell.cast(soothingmist, ni.members[1].unit);
				return true;
			end
		end
	end,
	["Expel Harm"] = function()
		if ni.spell.available(115072) then
			local curchannel = UnitChannelInfo("player");
			if ni.player.powerraw("chi") < 4
			 and ni.player.hp() <= 90
			 and not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning then
				ni.spell.cast(115072);
				return true;
			end
		end
	end,
	["DPS: SM"] = function()
		if ni.spell.available(116694) then
			local curchannel = UnitChannelInfo("player");
			if not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and ni.player.powerraw("chi") >= 1
			 and UnitAffectingCombat("player") then
				local vitalmists, _, _, count = ni.player.buff(118674);
				if vitalmists and count == 5 then
					if ni.spell.valid(ni.members[1].unit, surgingmist, false, true, true) then
						ni.spell.cast(surgingmist, ni.members[1].unit);
						return true;
					else
						ni.spell.cast(surgingmist, "player");
						return true;
					end
				end
			end
		end
	end,
	["DPS: RM"] = function()
		if ni.spell.available(115151) then
			local curchannel = UnitChannelInfo("player");
			if not ni.unit.buff(ni.members[1].unit, 115151, "player")
			 and not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and ni.player.powerraw("chi") >= 1
			 and UnitAffectingCombat("player") then
				if ni.spell.valid(ni.members[1].unit, 115151, false, true, true) then
					ni.spell.cast(115151, ni.members[1].unit);
					return true;
				end
			end
		end
	end,
	["DPS: BoK"] = function()
		if ni.spell.available(100784) then
			local curchannel = UnitChannelInfo("player");
			if UnitAffectingCombat("player")
			 and not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and ni.spell.valid("target", 100784, true, true)
			 and ni.player.powerraw("chi") >= 2 then
				local serpentszeal, _, _, _, _, _, sztime = ni.player.buff(127722);
				if not serpentszeal then
					ni.spell.cast(blackoutkick, "target");
					return true;
				else
					if sztime - GetTime() <= 2 then
						ni.spell.cast(blackoutkick, "target");
						return true;
					elseif ni.spell.available(100787) then
						ni.spell.cast(tigerpalm, "target");
					end
				end
			end
		end
	end,
	["DPS: TP"] = function()
		if ni.spell.available(100787) then
			local curchannel = UnitChannelInfo("player");
			if UnitAffectingCombat("player")
			 and not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and ni.spell.valid("target", 100787, true, true) then
				ni.spell.cast(tigerpalm, "target");
				return true;
			end
		end
	end,
	["DPS: Jab"] = function()
		if ni.spell.available(jab) then
			local curchannel = UnitChannelInfo("player");
			if UnitAffectingCombat("player")
			 and not ni.player.buff(101546)
			 and not UnitCastingInfo("player")
			 and curchannel ~= zenmeditation
			 and curchannel ~= cracklingjadelightning
			 and ni.player.powerraw("chi") < 1
			 and ni.spell.valid("target", jab, true, true) then
				ni.spell.cast(jab, "target");
				return true;
			end
		end
	end,
}
local function queue()
	local info1, info2, info3 = GetInstanceInfo();
	if IsInInstance() then
		if info2 == "party" then
			settings.current = settings.party;
			return mainqueue;
		elseif info2 == "raid" and (info3 == 3 or info3 == 5) then
			settings.current = settings.raid10;
			return raidqueue;
		elseif info2 == "raid" and (info3 == 4 or info3 == 6 or info3 == 7) then
			settings.current = settings.raid25;
			return raidqueue;
		end
	end
	settings.current = settings.master;
	return mainqueue;
end
ni.bootstrap.rotation("Mistweaver", queue, abilities);