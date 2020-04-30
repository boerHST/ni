local CreateFrame = CreateFrame

ni.frames.members = CreateFrame("frame", nil)
ni.frames.members:RegisterEvent("PARTY_MEMBERS_CHANGED")
ni.frames.members:RegisterEvent("RAID_ROSTER_UPDATE")
ni.frames.members:RegisterEvent("GROUP_ROSTER_UPDATE")
ni.frames.members:RegisterEvent("PARTY_CONVERTED_TO_RAID")
ni.frames.members:RegisterEvent("ZONE_CHANGED")
ni.frames.members:RegisterEvent("PLAYER_ENTERING_WORLD")
ni.frames.members_OnUpdate = function(self, elapsed)
	if ni.objects ~= nil and ni.functions.getobjects ~= nil then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			ni.members()
		end
	end
end
