local function start(queue, abilities, data, GUI)
	local profile = { };
	profile.loaded = false;
	profile.GUI = GUI;
	profile.data = data;
	function profile.execute(self)
		if not profile.loaded then
			if self.data ~= nil and #self.data > 0 then
				if ni.utils.loaddatafiles(self.data) then
					self.loaded = true
				end
			else
				self.loaded = true
			end
		end
		local temp_queue;
		if type(queue) == "function" then
			temp_queue = queue()
		else
			temp_queue = queue;
		end
		for i = 1, #temp_queue do
			local abilityinqueue = temp_queue[i]
			if abilities[abilityinqueue] ~= nil and abilities[abilityinqueue]() then
				break
			end
		end
	end;
	function profile.createGUI(self)
		if self.GUI ~= nil and #self.GUI > 0 then
			ni.GUI.AddFrame(self.GUI[1], self.GUI[2]);
		end
	end;
	function profile.destroyGUI(self)
		if self.GUI ~= nil and #self.GUI > 0 then
			ni.GUI.DestroyFrame(self.GUI[1]);
		end
	end;
	function profile.unload(self)
		if self.loaded then
			table.wipe(ni.data)
			self.loaded = false
		end
	end;
	return profile;
end
ni.bootstrap = {
	rotation = function(profile, queue, abilities, data, GUI)
		GUI = true and GUI or {};
		data = true and data or {}
		ni.debug.log("Loaded " .. profile)
		ni.rotation.profile[profile] = start(queue, abilities, data, GUI);
	end
}
