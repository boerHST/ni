-----------------------------------------------
----- Necessary tables for below functions ----
-----------------------------------------------
local frames = { };
local storedframes = { };
local framenames = { };
local generated_names = { };
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
local current_frame;
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
local function GUI_OnLeave(self, ...)
	PopBack(ni.GUI, ...);
end;
local function GUI_OnEnter(self, ...)
	PopOut(ni.GUI, ...);
end;
local function ResizeEntries(frame)
	local width = ni.GUI:GetWidth() - 16;
	for k, v in ipairs(frames[frame].items) do
		if v.isentry then
			if v.text then
				local button = v.checkbutton;
				local text = v.text;
				local editbox = v.editbox;
				local _, _, _, _, yOfs = text:GetPoint();
				local newpoint = (width/2) - (text:GetWidth()/2) - (editbox:GetWidth()/2) + button:GetWidth()/2;
				text:SetPoint("LEFT", newpoint, yOfs); 
			end
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
			elseif v.ismenu then
				local temp = v.menu:GetWidth() + 16;
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
					elseif v.ismenu then
						local temp = v.menu:GetWidth() + 16;
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
local function NumberOfFrames()
	local num_frames = 0;
	for k, v in pairs(frames) do
		num_frames = num_frames + 1;
	end
	return num_frames;
end
local function ChangeMainPageBack()
	local num_frames = NumberOfFrames();
	if num_frames > 1 then
		for k, v in pairs(frames) do
			if k ~= current_frame then
				frames[current_frame]:Hide();
				current_frame = k;
				v:Show();
				main_height = main_original_height;
				main_width = main_original_width;
				main_y = main_orignal_y;
				Resize(current_frame);
				return;
			end
		end
	end
end
local function ChangeMainPageForward()
	local num_frames = NumberOfFrames();
	if num_frames > 1 then
		for k, v in pairs(frames) do
			if k ~= current_frame then
				frames[current_frame]:Hide();
				current_frame = k;
				v:Show();
				main_height = main_original_height;
				main_width = main_original_width;
				main_y = main_orignal_y;
				Resize(current_frame);
				return;
			end
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
local function RandomVariable(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end
local function GenerateRandomName()
	local name = RandomVariable(20);
	while tContains(generated_names, name) do
		name = RandomVariable(20);
	end
	table.insert(generated_names, name);
	return name;
end
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
local function CreateRadial(frame, t, k, settings)
	local CheckButton = CreateFrame("CheckButton", nil, frame, "OptionsBaseCheckButtonTemplate");
	CheckButton:SetSize(0.1, 16);
	CheckButton:SetChecked(t.menu[k].selected);
	CheckButton:SetScript("OnEnter", GUI_OnEnter);
	CheckButton:SetScript("OnLeave", GUI_OnLeave);
	CheckButton:Show();
	function CheckButton.Check(bool)
		t.menu[k].selected = bool;
		CheckButton:SetChecked(bool);
	end;
	CheckButton:SetScript("OnClick", function(self)
		for k, v in pairs(frame:GetParent().items) do
			v.selected.Check(false);
		end
		self.Check(true);
		local text;
		if t.menu[k].text ~= nil then
			text = t.menu[k].text;
		else
			text = tostring(t.menu[k].value);
		end
		if settings ~= nil and t.key ~= nil then
			ni.utils.savesetting(settings, "settings/"..t.key, text);
		end
		frame:GetParent():GetParent().text:SetText(text);
		frame:GetParent().isshown = false;
		frame:GetParent():Hide();
	end);
	return CheckButton;
end
local function CreateMenuFrame(frame, t, settings)
	local Frame = CreateFrame("frame", nil, frame);
	Frame:SetBackdrop({
		bgFile = "Interface/Buttons/WHITE8X8",
		edgeFile = "Interface/Buttons/WHITE8X8",
		edgeSize = 1,
	});
	Frame:SetPoint("TOP", frame, "BOTTOM");
    Frame:SetBackdropColor(0,0,0,1);
    Frame:SetBackdropBorderColor(.8,.8,.8,1);
	Frame.items = { };
	Frame.isshown = false;
	local height = 0;
	for k, v in ipairs(t.menu) do
		local id = #Frame.items + 1;
		local item = CreateFrame("frame", nil, Frame);
		item:SetHeight(16);
		local text;
		if v.text == nil then
			text = v.value;
		else
			text = v.text;
		end
		item.text = CreateText(item, text);
		item.text:SetPoint("CENTER");
		item.text:SetJustifyH("CENTER");
		item.text:SetJustifyV("CENTER");
		item.selected = CreateRadial(item, t, k, settings);
		item.selected:SetPoint("LEFT", 0, 0);
		item.selected:SetCheckedTexture(nil)
		item.selected:SetDisabledCheckedTexture(nil);
		local width = item.text:GetStringWidth() + 8;
		item:SetWidth(width);
		Frame.items[id] = item;
		if v.selected then
			frame.text:SetText(text);
		end
		if id > 1 then
			item:SetPoint("TOP", Frame.items[id-1], "BOTTOM", 0, -2);
			height = height + 2;
		else
			item:SetPoint("TOP", 0, -4);
			height = height + 4
		end
		height = height + item:GetHeight();
	end
	local width = 0;
	for k, v in pairs(Frame.items) do
		local temp = v:GetWidth() + 16;
		if temp > width then
			width = temp;
		end
	end
	for k, v in pairs(Frame.items) do
		v:SetWidth(width);
	end
	Frame:SetSize(width, height + 4);
	Frame:SetScript("OnEnter", GUI_OnEnter);
	Frame:SetScript("OnLeave", GUI_OnLeave);
	Frame:Hide();
	return Frame;
end
local function CreateMenu(frame, t, settings)
	local DropDownMenu = CreateFrame("Button", nil, frame);
	DropDownMenu:SetBackdrop({
		bgFile = "Interface/Buttons/WHITE8X8",
		edgeFile = "Interface/Buttons/WHITE8X8",
		edgeSize = 1,
	});
    DropDownMenu:SetBackdropColor(0,0,0,0.5);
    DropDownMenu:SetBackdropBorderColor(.8,.8,.8,.5);	
	DropDownMenu:Show();
	DropDownMenu.text = CreateText(DropDownMenu, "");
	local submenu = CreateMenuFrame(DropDownMenu, t, settings);
	DropDownMenu:SetScript("OnEnter", GUI_OnEnter);
	DropDownMenu:SetScript("OnLeave", GUI_OnLeave);
	DropDownMenu:SetScript("OnClick", function(self, ...)
		if submenu.isshown then
			submenu.isshown = false;
			submenu:Hide();
		else
			submenu.isshown = true;
			submenu:Show();
		end
	end);
	local width = 0;
	for k, v in pairs(submenu.items) do
		local temp = v:GetWidth();
		if temp > width then
			width = temp;
		end
	end
	DropDownMenu:SetSize(width, 16);
	return DropDownMenu;
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
	local combwidth;
	if t.menu == nil then
		local EditBox;
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
		CheckButton:SetPoint("LEFT", 0, -(12-(cbheight/2)));
		CheckButton:SetScript("OnEnter", GUI_OnEnter);
		CheckButton:SetScript("OnLeave", GUI_OnLeave);
		TempFrame.checkbutton = CheckButton;
		local Text = CreateText(TempFrame, t.text);
		TempFrame.text = Text;
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
		local twidth = Text:GetWidth();
		local ebwidth = EditBox:GetWidth();
		local theight = Text:GetStringHeight();
		combwidth = cbwidth + twidth + ebwidth + 48;
		Text:SetPoint("LEFT", cbwidth, 0.5);
		TempFrame.isentry = true;
	else
		local Menu = CreateMenu(TempFrame, t, frames[frame].settingsfile);
		Menu:SetPoint("CENTER");
		combwidth = Menu:GetWidth() + 48;
		TempFrame.menu = Menu;
		TempFrame.ismenu = true;
	end
	TempFrame:SetWidth(combwidth);
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
				elseif v.type == "dropdown" and v.key ~= nil then
					local value = ni.utils.getsetting(t.settingsfile, "settings/"..v.key, "string");
					if value ~= nil then
						for _, v2 in ipairs(v.menu) do
							local text;
							if v2.text ~= nil then
								text = v2.text;
							else
								text = v2.value;
							end
							if tostring(text) == value then
								v2.selected = true;
							else
								v2.selected = false;
							end
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
		elseif v.type == "dropdown" then
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
local function HideMainPages()
	ni.GUI.leftbutton:Hide();
	ni.GUI.rightbutton:Hide();
end
local function ShowMainPages()
	ni.GUI.leftbutton:Show();
	ni.GUI.rightbutton:Show();
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
		local LeftButton = CreateFrame("Button", nil, GUI);
		LeftButton:RegisterForClicks("LeftButtonUp");
		LeftButton:SetSize(24, 24);
		LeftButton:SetPoint("TOPLEFT", 4, -9);
		LeftButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up");	
		LeftButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down");
		LeftButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled");
		LeftButton:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD");
		LeftButton:SetScript("OnClick", function(...)
			ChangeMainPageBack();
		end);
		LeftButton:SetScript("OnEnter", function(self, ...)
			PopOut(ni.GUI, ...);
		end);
		LeftButton:SetScript("OnLeave", function(self, ...)
			PopBack(ni.GUI, ...);
		end);
		LeftButton:Hide();
		GUI.leftbutton = LeftButton;
		local RightButton = CreateFrame("Button", nil, GUI);
		RightButton:RegisterForClicks("LeftButtonUp");
		RightButton:SetSize(24, 24);
		RightButton:SetPoint("TOPRIGHT", -4, -9);
		RightButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up");	
		RightButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down");
		RightButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled");
		RightButton:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD");
		RightButton:SetScript("OnClick", function(...)
			ChangeMainPageForward();
		end);
		RightButton:SetScript("OnEnter", function(self, ...)
			PopOut(ni.GUI, ...);
		end);
		RightButton:SetScript("OnLeave", function(self, ...)
			PopBack(ni.GUI, ...);
		end);
		RightButton:Hide();
		GUI.rightbutton = RightButton;
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
		if v.name == name then
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
		local k = GetStoredTable(name);
		if k == nil then
			NewFrame(name);
			ApplySettings(name, t);
			if frames[name].pages and #frames[name].pages > 0 then
				frames[name].currentpage = 1;
			end
		else
			local f = table.remove(storedframes, k);
			rawset(frames, name, f);
		end
		local num_frames = NumberOfFrames();
		if num_frames == 0 then
			ni.GUI:Hide();
		else
			if num_frames > 1 then
				ShowMainPages();
				frames[name]:Hide();
				Resize(current_frame);
				frames[current_frame]:Show();
			else
				HideMainPages();
				current_frame = name;
				frames[name]:Show();
				Resize(name, true);
			end
			ni.GUI:Show();
		end
	end;
	ni.GUI.DestroyFrame = function(name)
		local temp = ni.GUI.GetFrame(name);
		if temp ~= nil then
			temp:Hide();
			table.insert(storedframes, temp);
			frames[name] = nil;
		end
		CreatedFramesByName()
		if #framenames == 0 then
			ni.GUI:Hide();
		else
			if #framenames > 1 then
				ShowMainPages();
			else
				HideMainPages();
			end
			main_width = main_original_width;
			main_height = main_original_height;
			main_y = main_original_y;
			if current_frame == name then
				for k, v in pairs(frames) do
					current_frame = k;
					break;
				end
			end
			frames[current_frame]:Show();
			Resize(current_frame);
			ni.GUI:Show();
		end
	end
end