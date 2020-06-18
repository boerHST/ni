-----------------------------------------------
----- Necessary tables for below functions ----
-----------------------------------------------
local frames = { };
local storedframes = { };
local framenames = { };
-----------------------------------------------
------- Local variables for the GUI -----------
-----------------------------------------------
local main_width = 60;
local main_original_width = main_width;
local main_height = 70;
local main_original_height = main_height;
local main_y = 55;
local main_original_y = main_y;
local original_offset = 45;
local offset = original_offset;
-----------------------------------------------
----- Local functions for movement/sizing -----
-----------------------------------------------
local function ApplyLayout()
	local distance = main_y;
	if ni.GUI.isOpen then
		distance = distance - offset;
	end
	ni.GUI:ClearAllPoints();
	ni.GUI:SetPoint("TOP", UIParent, "TOP", 0, distance);
end
local function PopOut(self, ...)
	self.PopTimer = 0.15;
	self.PopDirection = 1;
end
local function PopBack(self, ...)
	self.PopTimer = 0.5;
	self.PopDirection = -1;
end
local function PerformOpen()
	ni.GUI.PopDirection = nil;
	ni.GUI:ClearAllPoints();
	ni.GUI.isOpen = true;
	ApplyLayout();
end
local function PerformClose()
	ni.GUI.PopDirection = nil;
	ni.GUI:ClearAllPoints();
	ni.GUI.isOpen = false
	ApplyLayout();
end
local function Popper(self, ...)
	local duration = ...;
	if self.PopDirection then
		self.PopTimer = self.PopTimer - duration;
		if self.PopTimer < 0 then
			if self.PopDirection > 0 then
				PerformOpen();
			else
				PerformClose();
			end
		end
	end
end
local function ResizeEntries(frame)
	local width = ni.GUI:GetWidth() - 16;
	for k, v in ipairs(frames[frame].items) do
		if v.isentry then
			local button = v.checkbutton;
			local text = v.text;
			local editbox = v.editbox;
			local _, _, _, _, yOfs = text:GetPoint();
			local newpoint = (width/2) - (text:GetWidth()/2) - (editbox:GetWidth()/2) + button:GetWidth()/2;
			text:SetPoint("LEFT", newpoint, yOfs); 
		end
	end
	if frames[frame].pages ~= nil and #frames[frame].pages > 0 then
		if frames[frame].pages[frames[frame].currentpage].items then
			for k, v in ipairs(frames[frame].pages[frames[frame].currentpage].items) do
				if v.isentry then
					local button = v.checkbutton;
					local text = v.text;
					local editbox = v.editbox;
					local _, _, _, _, yOfs = text:GetPoint();
					local newpoint = (width/2) - (text:GetWidth()/2) - (editbox:GetWidth()/2) + button:GetWidth()/2;
					text:SetPoint("LEFT", newpoint, yOfs); 
				end
			end
		end
	end
end
local function Resize(frame, reset)
	local reset = reset and true or false;
	if frames[frame] ~= nil and frames[frame]:IsShown() then
		local width = main_width;
		local height = 12;
		for k, v in ipairs(frames[frame].items) do
			height = height + v:GetHeight() + 4
			if v.isentry then
				local temp = v.checkbutton:GetWidth() + v.text:GetStringWidth() + v.editbox:GetWidth() + 16;
				if temp > width then
					width = temp;
				end
			elseif v.istext then
				local temp = v:GetStringWidth() + 16;
				if temp > width then
					width = temp;
				end
			end
		end
		if frames[frame].pages ~= nil and #frames[frame].pages > 0 then
			for k, v in ipairs(frames[frame].pages) do
				local temp = v:GetPageWidth();
				if temp > width then
					width = temp;
				end
			end
			local page_height = 16;
			if frames[frame].pages[frames[frame].currentpage].items then
				for k, v in ipairs(frames[frame].pages[frames[frame].currentpage].items) do
					page_height = page_height + v:GetHeight() + 4;
					if v.isentry then
						local temp = v.checkbutton:GetWidth() + v.text:GetStringWidth() + v.editbox:GetWidth() + 16;
						if temp > width then
							width = temp;
						end
					elseif v.istext then
						local temp = v:GetStringWidth() + 16;
						if temp > width then
							width = temp;
						end
					end
				end
			end
			frames[frame].pages[frames[frame].currentpage]:SetHeight(page_height);
			height = height + page_height;
		end
		height = height + 16;
		main_height = height;
		main_width = width;
		main_y = height - 15;
		offset = height - 25;
		ni.GUI:SetWidth(width);
		frames[frame]:SetHeight(height);
		ni.GUI:SetHeight(height);
		ResizeEntries(frame);
		if reset then
			ni.GUI:SetPoint("TOP", UIParent, "TOP", 0, main_y);
		else
			ApplyLayout();
		end
	else
		main_height = main_original_height;
		main_width = main_original_width;
		main_y = main_original_y;
		offset = original_offset;
		ni.GUI:SetWidth(main_original_width);
		ni.GUI:SetHeight(main_original_height);	
		if reset then
			ni.GUI:SetPoint("TOP", UIParent, "TOP", 0, main_original_y);
		else
			ApplyLayout();
		end
	end
end
local function ChangePageBack(frame, page)
	local num_pages = #frame.pages;
	if num_pages >= page then
		local next_page = page-1;
		if next_page == 0 then
			next_page = num_pages;
		end
		frame.pages[next_page]:Show();
		frame.pages[page]:Hide();
		frame.currentpage = next_page;
		Resize(frame.name);
	end
end
local function ChangePageForward(frame, page)
	local num_pages = #frame.pages;
	if num_pages >= page then
		local next_page = page+1;
		if next_page > num_pages then
			next_page = 1;
		end
		frame.pages[next_page]:Show();
		frame.pages[page]:Hide();
		frame.currentpage = next_page;
		Resize(frame.name);
	end
end
-----------------------------------------------
----- Local functions to create the frames ----
-----------------------------------------------
local function CreateText(frame, text)
	local TextFrame = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
	TextFrame:SetPoint("CENTER", 0, 0);
	TextFrame:SetText(text);
	TextFrame:SetTextHeight(12);
	TextFrame:SetJustifyH("CENTER");
	TextFrame:SetJustifyV("CENTER");
	TextFrame.istext = true;
	return TextFrame;
end
local function CreateCheckBox(frame, t, settings)
	local CheckButton = CreateFrame("CheckButton", nil, frame, "OptionsBaseCheckButtonTemplate");
	CheckButton:SetPoint("LEFT", 0, 0);
	CheckButton:SetSize(26, 26);
	CheckButton:SetChecked(t.enabled);
	CheckButton:SetHitRectInsets(0,0,0,0);
	CheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				t.enabled = true;
			else
				t.enabled = false;
			end
			if settings ~= nil and t.key ~= nil then
				ni.utils.savesetting(settings, "settings/"..t.key.."_enabled", t.enabled);
			end
		end);
	return CheckButton;
end
local function CreateBlankSquare(frame)
	local Frame = CreateFrame("frame", nil, frame);
	Frame:SetSize(26, 26);
	Frame:Show();
	return Frame;
end
local function CreateEditBox(frame, t, settings)
	local EditBox = CreateFrame("EditBox", nil, frame);
	EditBox:SetSize(30, 14);
	EditBox:SetAutoFocus(false);
	EditBox:SetFontObject("GameFontHighlight");
	EditBox:SetPoint("RIGHT", -4, 0);
	EditBox:SetJustifyH("CENTER");
	EditBox:SetJustifyV("CENTER");
	EditBox:EnableMouse(true);
	EditBox:SetBackdrop({
		bgFile = "Interface/Buttons/WHITE8X8",
		edgeFile = "Interface/Buttons/WHITE8X8",
		edgeSize = 1,
	});
    EditBox:SetBackdropColor(0,0,0,0.5)
    EditBox:SetBackdropBorderColor(.8,.8,.8,.5)
	EditBox:SetMaxLetters(3);
	EditBox:SetMultiLine(false);
	EditBox:SetNumeric();
	EditBox:SetNumber(t.value);
	EditBox:SetScript("OnEnterPressed", function(self)
		t.value = self:GetNumber();
		if settings ~= nil and t.key ~= nil then
			ni.utils.savesetting(settings, "settings/"..t.key.."_value", t.value);
		end
		self:ClearFocus();
	end)
	EditBox:SetScript("OnEscapePressed", function(self)
		self:SetNumber(t.value);
		self:ClearFocus();
	end)
	return EditBox;
end
local function CreateEntry(frame, i, t)
	local f;
	local distance = -16;
	if frames[frame].currentpage then
		f = frames[frame].pages[frames[frame].currentpage];
		distance = -22;
	else
		f = frames[frame];
	end
	if not f.items then
		f.items = { };
	end
	local id = #f.items + 1;
	local TempFrame = CreateFrame("frame", nil, f);
	TempFrame:SetHeight(16);
	TempFrame:SetPoint("LEFT", 4, 0);
	TempFrame:SetPoint("RIGHT", -4, 0);
	TempFrame:Show();
	local CheckButton;
	if t.enabled ~= nil then
		CheckButton = CreateCheckBox(TempFrame, t, frames[frame].settingsfile)
		TempFrame.hascheck = true;
	else
		CheckButton = CreateBlankSquare(TempFrame);
		TempFrame.hascheck = false;
	end
	local cbwidth = CheckButton:GetWidth();
	local cbheight = CheckButton:GetHeight();
	local Text = CreateText(TempFrame, t.text);
	TempFrame.checkbutton = CheckButton;
	TempFrame.text = Text;
	local EditBox;
	if t.value ~= nil then
		EditBox = CreateEditBox(TempFrame, t, frames[frame].settingsfile);
	else
		EditBox = CreateBlankSquare(TempFrame);
		EditBox:SetPoint("RIGHT", -4, 0);
	end
	EditBox:SetScript("OnEnter", function(self, ...)
		PopOut(ni.GUI, ...);
	end);
	EditBox:SetScript("OnLeave", function(self, ...) 
		PopBack(ni.GUI, ...);
	end);
	TempFrame.editbox = EditBox;
	CheckButton:SetScript("OnEnter", function(self, ...)
		PopOut(ni.GUI, ...);
	end);
	CheckButton:SetScript("OnLeave", function(self, ...) 
		PopBack(ni.GUI, ...);
	end);
	local twidth = Text:GetWidth();
	local ebwidth = EditBox:GetWidth();
	local theight = Text:GetStringHeight();
	CheckButton:SetPoint("LEFT", 0, -(12-(cbheight/2)));
	local combwidth = cbwidth + twidth + ebwidth + 48;
	Text:SetPoint("LEFT", cbwidth, 0.5);
	TempFrame:SetWidth(combwidth);
	TempFrame.isentry = true;
	f.items[id] = TempFrame;
	if id > 1 then
		TempFrame:SetPoint("TOP", f.items[id-1], "BOTTOM", 0, -4);
	else
		TempFrame:SetPoint("TOP", 0, distance);
	end
end
local function CreateCenteredText(frame, text)
	local f;
	local distance = -16;
	if frames[frame].currentpage then
		f = frames[frame].pages[frames[frame].currentpage];
		distance = -22;
	else
		f = frames[frame];
	end
	if not f.items then
		f.items = { };
	end
	local id = #f.items + 1;
	local TextFrame = CreateText(f, text)
	TextFrame:SetPoint("LEFT", 0, 0);
	TextFrame:SetPoint("RIGHT", 0, 0);
	f.items[id] = TextFrame;
	if id > 1 then
		TextFrame:SetPoint("TOP", f.items[id-1], "BOTTOM", 0, -4);
	else
		TextFrame:SetPoint("TOP", 0, distance);
	end
end
local function NewFrame(frame)
	frames[frame] = CreateFrame("frame", nil, ni.GUI);
	frames[frame].name = frame;
	frames[frame]:SetHeight(16);
	frames[frame]:SetPoint("LEFT", 0, 0);
	frames[frame]:SetPoint("RIGHT", 0, 0);
	frames[frame].Close = function(self)
		self:Hide();
		Resize(frame, true);
	end
	frames[frame].Open = function(self)
		self:Show();
		Resize(frame, true);
	end
	frames[frame]:Show();
end
local function CreatePage(frame, page, t)
	local Frame = CreateFrame("frame", nil, frames[frame]);
	Frame.page = page;
	Frame.ispage = true;
	Frame:SetHeight(16);
	Frame:SetPoint("LEFT", 0, 0);
	Frame:SetPoint("RIGHT", 0, 0);
	local LeftButton = CreateFrame("Button", nil, Frame);
	LeftButton:RegisterForClicks("LeftButtonUp");
	LeftButton:SetSize(24, 24);
	LeftButton:SetPoint("TOPLEFT", 4, -1);
	LeftButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up");	
	LeftButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down");
	LeftButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled");
	LeftButton:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD");
	LeftButton:SetScript("OnClick", function(...)
		ChangePageBack(frames[frame], Frame.page);
	end);
	LeftButton:SetScript("OnEnter", function(self, ...)
		PopOut(ni.GUI, ...);
	end);
	LeftButton:SetScript("OnLeave", function(self, ...)
		PopBack(ni.GUI, ...);
	end);
	Frame.leftbutton = LeftButton;
	local RightButton = CreateFrame("Button", nil, Frame);
	RightButton:RegisterForClicks("LeftButtonUp");
	RightButton:SetSize(24, 24);
	RightButton:SetPoint("TOPRIGHT", -4, -1);
	RightButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up");	
	RightButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down");
	RightButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled");
	RightButton:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD");
	RightButton:SetScript("OnClick", function(...)
		ChangePageForward(frames[frame], Frame.page);
	end);
	RightButton:SetScript("OnEnter", function(self, ...)
		PopOut(ni.GUI, ...);
	end);
	RightButton:SetScript("OnLeave", function(self, ...)
		PopBack(ni.GUI, ...);
	end);
	Frame.rightbutton = RightButton;
	local TextFrame;
	if t.text ~= nil then
		TextFrame = CreateText(Frame, t.text);
		TextFrame:SetPoint("TOPLEFT", 0, -6);
		TextFrame:SetPoint("TOPRIGHT", 0, -6);
	end
	Frame.text = TextFrame;
	Frame.GetPageWidth = function(self)
		local width = 0;
		if self.text ~= nil then
			width = width + self.text:GetStringWidth();
		end
		width = width + self.leftbutton:GetWidth() + self.rightbutton:GetWidth() + 16;
		return width;
	end
	local id = #frames[frame].items;
	if id > 1 then
		Frame:SetPoint("TOP", frames[frame].items[id-1], "BOTTOM", 0, -4);
	else
		Frame:SetPoint("TOP", 0, -16);
	end
	if page == 1 then
		Frame:Show();
	else
		Frame:Hide();
	end
	frames[frame].pages[page] = Frame;
end
local function CreateSeparator(frame)
	local f;
	local distance = -16;
	if frames[frame].currentpage then
		f = frames[frame].pages[frames[frame].currentpage];
		distance = -22;
	else
		f = frames[frame];
	end
	if not f.items then
		f.items = { };
	end
	local id = #f.items + 1;
	local separator = CreateFrame("frame", nil, f);
	separator:SetHeight(4);
	separator:Show();
	separator.texture = separator:CreateTexture();
	separator.texture:SetTexture(.8,.8,.8,.5);
	separator.texture:SetPoint("LEFT", 0, 0);
	separator.texture:SetPoint("RIGHT", 0, 0);
	separator.texture:SetHeight(2);
	separator:SetPoint("LEFT", 4, 0);
	separator:SetPoint("RIGHT", -4, 0);
	f.items[id] = separator;
	if id > 1 then
		separator:SetPoint("TOP", f.items[id-1], "BOTTOM", 0, -4);
	else
		separator:SetPoint("TOP", 0, distance);
	end
end
local function ToggleFrame(frame)
	if frames[frame]:IsShown() then
		frames[frame]:Hide();
	else
		frames[frame]:Show();
	end
end
local function UpdateSettings(t)
	if t.settingsfile then
		if ni.utils.fileexists("Settings\\"..t.settingsfile) then
			for k, v in ipairs(t) do
				if v.type == "entry" and v.key ~= nil then
					if v.enabled ~= nil then
						local bool = ni.utils.getsetting(t.settingsfile, "settings/"..v.key.."_enabled", "bool");
						if bool ~= nil then
							v.enabled = bool;
						end
					end
					if v.value ~= nil then
						local value = ni.utils.getsetting(t.settingsfile, "settings/"..v.key.."_value", "int");
						if value ~= nil then
							v.value = value;
						end
					end
				end
			end
		end
	end
end
local function ApplySettings(name, t)
	if t.settingsfile then
		UpdateSettings(t);
		frames[name].settingsfile = t.settingsfile;
	end
	for k, v in ipairs(t) do
		if v.type == "title" then
			CreateCenteredText(name, v.text);
		elseif v.type == "separator" then
			CreateSeparator(name);
		elseif v.type == "entry" then
			CreateEntry(name, k, v);
		elseif v.type == "page" then
			if frames[name].pages == nil then
				frames[name].pages = { };
			end
			CreatePage(name, v.number, v);
			frames[name].currentpage = v.number;
		end
	end
end
local function MainFrame()
	if not created then
		ni.GUI = CreateFrame("frame", nil, UIParent);
		local GUI = ni.GUI;
		GUI:ClearAllPoints();
		GUI:SetFrameLevel(0);
		GUI:SetWidth(main_width);
		GUI:SetHeight(main_height);
		GUI:EnableMouse(true);
		GUI:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
						edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
						tile = true, tileSize = 16, edgeSize = 16, 
						insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		GUI:SetBackdropColor(0,0,0,1);
		GUI:SetPoint("TOP", UIParent, "TOP", 0, main_y);
		GUI:SetScript("OnEnter", function(self, ...)
			PopOut(self, ...);
		end);
		GUI:SetScript("OnLeave", function(self, ...) 
			PopBack(self, ...);
		end);
		GUI:SetScript("OnUpdate", function(self, ...)
			Popper(self, ...);
		end);
		GUI:Show();
		created = true;
	end
end
local function CreatedFramesByName()
	table.wipe(framenames);
	for k, v in pairs(frames) do
		if v.name then
			table.insert(framenames, v.name);
		end
	end
	return framenames;
end
local function GetStoredTable(name)
	for k, v in pairs(storedframes) do
		if v == name then
			return k;
		end
	end
	return nil;
end
if not ni.GUI then
	local created = false;
	ni.GUI = { };
	MainFrame();
	CreatedFramesByName()
	if #framenames == 0 then
		ni.GUI:Hide();
	else
		ni.GUI:Show();
	end
	ni.GUI.GetFrame = function(name)
		return frames[name];
	end
	ni.GUI.AddFrame = function(name, t)
		local f = table.remove(storedframes, GetStoredTable(name));
		if not f then
			NewFrame(name);
			ApplySettings(name, t);
			if frames[name].pages and #frames[name].pages > 0 then
				frames[name].currentpage = 1;
			end
			Resize(name, true);
		else
			rawset(frames, name, f);
			f:Show();
			Resize(name, true);
		end
		CreatedFramesByName()
		if #framenames == 0 then
			ni.GUI:Hide();
		else
			ni.GUI:Show();
		end
	end;
	ni.GUI.DestroyFrame = function(name)
		local temp = ni.GUI.GetFrame(name);
		if temp ~= nil then
			temp:Hide();
			table.insert(storedframes, temp);
			frames[name] = nil;
			Resize(name, true);
		end
		CreatedFramesByName()
		if #framenames == 0 then
			ni.GUI:Hide();
		else
			ni.GUI:Show();
		end
	end
end