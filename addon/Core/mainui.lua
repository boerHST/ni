local main_ui = {};

local ui = {
	icon = {
		x = 75.70,
		y = -6.63
	},
	main = {
		point = "CENTER",
		relativePoint = "CENTER",
		x = 300,
		y = 180
	}
}

if ni.vars.ui then
	ui = ni.vars.ui;
else
	ni.vars.ui = ui;
end

local function moveIcon(self)
	local centerX, centerY = Minimap:GetCenter();
	local x, y = GetCursorPosition();
	x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY;
	centerX, centerY = math.abs(x), math.abs(y);
	centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2)) * 76, (centerY / math.sqrt(centerX^2 + centerY^2)) * 76
	centerX = x < 0 and -centerX or centerX;
	centerY = y < 0 and -centerY or centerY;
	self:ClearAllPoints();
	self:SetPoint("CENTER", centerX, centerY);
	ni.vars.ui.icon.x = centerX;
	ni.vars.ui.icon.y = centerY;
end

local uiScale = GetCVar("uiScale") or 1;
local backdrop = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
	tile = true, tileSize = 16, edgeSize = 16, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
};

main_ui.main = CreateFrame("frame", nil, UIParent);
local frame = main_ui.main;
frame:ClearAllPoints();
frame:SetMovable(true);
frame:EnableMouse(true);
frame:RegisterForDrag("LeftButton");
frame:SetScript("OnDragStart", frame.StartMoving);
frame:SetScript("OnDragStop", function()
	local point, _, relativePoint, offset_x, offset_y = frame:GetPoint();
	ni.vars.ui.main.point = point;
	ni.vars.ui.main.relativePoint = relativePoint;
	ni.vars.ui.main.x = offset_x;
	ni.vars.ui.main.y = offset_y;
	frame:StopMovingOrSizing();
end);
frame:SetWidth(260);
frame:SetHeight(205);
frame:SetBackdrop(backdrop);
frame:SetPoint(ni.vars.ui.main.point, WorldFrame, ni.vars.ui.main.relativePoint, ni.vars.ui.main.x, ni.vars.ui.main.y);
frame:SetBackdropColor(0,0,0,1);
frame:Hide();

local function CreateText(frame, settext, offset_x, offset_y, r, g, b, a)
	local text = CreateFrame("frame", nil, frame);
	text:ClearAllPoints();
	text:SetHeight(20);
	text:SetWidth(200);
	text:SetPoint("TOP", frame, offset_x, offset_y);
	text.text = text:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
	text.text:SetAllPoints();
	text.text:SetJustifyH("CENTER");
	text.text:SetJustifyV("MIDDLE");
	text.text:SetText(settext);
	text.text:SetTextColor(r, g, b, a);
	return text;
end

local title = CreateText(frame, "Rotation Assistant", 0, -5, 0.2, 0.7, 1, 1);
local primary_text = CreateText(frame, "Select your primary rotation:", 0, -18, 0.1, 0.5, 0.8, 1);
local secondary_text = CreateText(frame, "Select your secondary rotation:", 0, -63, 0.1, 0.5, 0.8, 1);
local generic_text = CreateText(frame, "Select your generic rotation:", 0, -108, 0.1, 0.5, 0.8, 1);

local function GetFilename(file)
	return file:match("^.*\\(.*).lua$") or file
end

local profiles = ni.functions.getprofilesfor(select(2, UnitClass("player"))) or { };
tinsert(profiles, 1, "None");
local generic_profiles = ni.functions.getprofilesfor("Generic") or { };
tinsert(generic_profiles, 1, "None");

local ddm_name = ni.utils.GenerateRandomName();
local dropdownmenu = CreateFrame("frame", ddm_name, frame, "UIDropDownMenuTemplate");
dropdownmenu:ClearAllPoints();
dropdownmenu:SetPoint("TOP", 0, -36);
dropdownmenu:Show();
local primary = "None";
local primaryIndex = 1;
UIDropDownMenu_Initialize(dropdownmenu, function(self, level)
	local info = UIDropDownMenu_CreateInfo();
	local index = 0;
	for k, v in ipairs(profiles) do
		index = index + 1;
		local file = GetFilename(v);
		local checked = false;
		if ni.vars.profiles.primary == file then
			primary = file;
			primaryIndex = index;
			checked = true;
		end
		info.text = file;
		info.value = file;
		info.checked = checked;
		info.func = function(self)
			UIDropDownMenu_SetSelectedID(dropdownmenu, self:GetID());
			ni.vars.profiles.primary = self:GetText();
		end;
		UIDropDownMenu_AddButton(info, level);
	end
end)
UIDropDownMenu_SetWidth(dropdownmenu, 150);
UIDropDownMenu_SetButtonWidth(dropdownmenu, 174);
UIDropDownMenu_JustifyText(dropdownmenu, "CENTER");	
UIDropDownMenu_SetSelectedID(dropdownmenu, primaryIndex);
UIDropDownMenu_SetText(dropdownmenu, primary);

local ddm2_name = ni.utils.GenerateRandomName();
local dropdownmenu2 = CreateFrame("frame", ddm2_name, frame, "UIDropDownMenuTemplate");
dropdownmenu2:ClearAllPoints();
dropdownmenu2:SetPoint("TOP", 0, -81);
dropdownmenu2:Show();
local secondary = "None";
local secondaryIndex = 1;
UIDropDownMenu_Initialize(dropdownmenu2, function(self, level)
	local info = UIDropDownMenu_CreateInfo();
	local index = 0;
	for k, v in ipairs(profiles) do
		index = index + 1;
		local file = GetFilename(v);
		local checked = false;
		if ni.vars.profiles.secondary == file then
			secondary = file;
			secondaryIndex = index;
			checked = true;
		end
		info.text = file;
		info.value = file;
		info.checked = checked;
		info.func = function(self)
			UIDropDownMenu_SetSelectedID(dropdownmenu2, self:GetID());
			ni.vars.profiles.secondary = self:GetText();
		end;
		UIDropDownMenu_AddButton(info, level);
	end
end)
UIDropDownMenu_SetWidth(dropdownmenu2, 150);
UIDropDownMenu_SetButtonWidth(dropdownmenu2, 174);
UIDropDownMenu_JustifyText(dropdownmenu2, "CENTER");	
UIDropDownMenu_SetSelectedID(dropdownmenu2, secondaryIndex);
UIDropDownMenu_SetText(dropdownmenu2, secondary);

local ddm3_name = ni.utils.GenerateRandomName();
local dropdownmenu3 = CreateFrame("frame", ddm3_name, frame, "UIDropDownMenuTemplate");
dropdownmenu3:ClearAllPoints();
dropdownmenu3:SetPoint("TOP", 0, -126);
dropdownmenu3:Show();
local generic = "None";
local genericIndex = 1;
UIDropDownMenu_Initialize(dropdownmenu3, function(self, level)
	local info = UIDropDownMenu_CreateInfo();
	local index = 0;
	for k, v in ipairs(generic_profiles) do
		index = index + 1;
		local file = GetFilename(v);
		local checked = false;
		if ni.vars.profiles.generic == file then
			generic = file;
			genericIndex = index;
			checked = true;
		end
		info.text = file;
		info.value = file;
		info.checked = checked;
		info.func = function(self)
			UIDropDownMenu_SetSelectedID(dropdownmenu3, self:GetID());
			ni.vars.profiles.generic = self:GetText();
		end;
		UIDropDownMenu_AddButton(info, level);
	end
end)
UIDropDownMenu_SetWidth(dropdownmenu3, 150);
UIDropDownMenu_SetButtonWidth(dropdownmenu3, 174);
UIDropDownMenu_JustifyText(dropdownmenu3, "CENTER");	
UIDropDownMenu_SetSelectedID(dropdownmenu3, genericIndex);
UIDropDownMenu_SetText(dropdownmenu3, generic);

local mainsettings = CreateFrame("frame", nil, frame);
mainsettings:ClearAllPoints();
mainsettings:SetWidth(180);
mainsettings:SetHeight(400);
mainsettings:SetPoint("TOPRIGHT", frame, 175, 0);
mainsettings:SetBackdrop(backdrop);
mainsettings:EnableMouse(true);
mainsettings:SetBackdropColor(0,0,0,1);
mainsettings:Hide();

local settings = CreateFrame("frame", nil, frame);
settings:ClearAllPoints();
settings:SetWidth(200);
settings:SetHeight(305);
settings:SetPoint("TOPLEFT", frame, -195, 0);
settings:SetBackdrop(backdrop);
settings:EnableMouse(true);
settings:SetBackdropColor(0,0,0,1);
settings:Hide();

local closeframebutton = CreateFrame("BUTTON", nil, frame, "UIPanelButtonTemplate");
closeframebutton:SetWidth(62);
closeframebutton:SetHeight(22);
closeframebutton:SetText("Close");
closeframebutton:SetPoint("BOTTOM", frame, 0, 5);
closeframebutton:SetAlpha(1);
closeframebutton:SetScript("OnClick", function()
	if frame:IsShown() then
		frame:Hide();
	end
end);

local settingsbutton = CreateFrame("BUTTON", nil, frame, "UIPanelButtonTemplate");
settingsbutton:SetWidth(125);
settingsbutton:SetHeight(22);
settingsbutton:SetText("Rotation Settings");
settingsbutton:SetPoint("BOTTOM", frame, -63, 28);
settingsbutton:SetAlpha(1);
settingsbutton:SetScript("OnClick", function()
	if settings:IsShown() then
		settings:Hide();
	else
		settings:Show();
	end
end);

local mainsettingsbutton =  CreateFrame("BUTTON", nil, frame, "UIPanelButtonTemplate");
mainsettingsbutton:SetWidth(125);
mainsettingsbutton:SetHeight(22);
mainsettingsbutton:SetText("Main Settings");
mainsettingsbutton:SetPoint("BOTTOM", frame, 63, 26);
mainsettingsbutton:SetAlpha(1);
mainsettingsbutton:SetScript("OnClick", function()
	if mainsettings:IsShown() then
		mainsettings:Hide();
	else
		mainsettings:Show();
	end
end);

local function CreateDropDownText(frame, settext, offset_x, offset_y)
	local text = CreateFrame("frame", nil, frame);
	text:ClearAllPoints();
	text:SetHeight(20);
	text:SetWidth(200);
	text:SetPoint("TOP", frame, offset_x, offset_y);
	text.text = text:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
	text.text:SetAllPoints();
	text.text:SetJustifyH("CENTER");
	text.text:SetJustifyV("MIDDLE");
	text.text:SetText(settext);
	return text;
end

local function CreateKeyDropDown(frame, keys, offset_x, offset_y, var)
	local name = ni.utils.GenerateRandomName();
	local dropdown = CreateFrame("frame", name, frame, "UIDropDownMenuTemplate");
	dropdown:ClearAllPoints();
	dropdown:SetPoint("TOP", frame, offset_x, offset_y);
	dropdown:Show();
	local set = "None";
	local setIndex = 1;
	UIDropDownMenu_Initialize(dropdown, function(self, level)
		local info = UIDropDownMenu_CreateInfo();
		local index = 0;
		for k, v in pairs(keys) do
			index = index + 1;
			local checked = false;
			if ni.vars.hotkeys[var] == v then
				set = v;
				setIndex = index;
				checked = true;
			end
			info.text = v;
			info.value = v;
			info.checked = checked;
			info.func = function(self)
				UIDropDownMenu_SetSelectedID(dropdown, self:GetID());
				ni.vars.hotkeys[var] = self:GetText();
			end
			UIDropDownMenu_AddButton(info, level);
		end
	end);
	UIDropDownMenu_SetWidth(dropdown, 100);
	UIDropDownMenu_SetButtonWidth(dropdown, 124);
	UIDropDownMenu_JustifyText(dropdown, "CENTER");
	UIDropDownMenu_SetSelectedID(dropdown, setIndex);
	UIDropDownMenu_SetText(dropdown, set);
	return dropdown
end

local function CreateEditBox(frame, offset_x, offset_y, var)
	local edit = CreateFrame("EditBox", nil, frame);
	edit:SetHeight(20)
	edit:SetWidth(124);
	edit:SetPoint("TOP", frame, offset_x, offset_y)
	edit:SetFontObject("GameFontHighlight");
	edit:SetAutoFocus(false);
	edit:SetJustifyH("CENTER");
	edit:SetJustifyV("CENTER");
	edit:EnableMouse(true);
	edit:SetBackdrop({
		bgFile = "Interface/Buttons/WHITE8X8",
		edgeFile = "Interface/Buttons/WHITE8X8",
		edgeSize = 1,
	});
	edit:SetBackdropColor(0,0,0,0.5);
	edit:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.5);
	edit:SetScript("OnEnterPressed", function(self)
		ni.vars.units[var] = self:GetText() or "";
		self:ClearFocus();
	end);
	edit:SetScript("OnEscapePressed", function(self)
		self:SetText(ni.vars.units[var]);
		self:ClearFocus();
	end);
	edit:SetText(ni.vars.units[var]);
	edit:Show();
	return edit;
end

--Main Settings drop downs
local keys = {
	"None",
	"F1",
	"F2",
	"F3",
	"F4",
	"F5",
	"F6",
	"F7",
	"F8",
	"F9",
	"F10",
	"F11",
	"F12"
}
local header = CreateText(mainsettings, "Reload after changing", 0, -5, 0.8, 0.1, 0.1, 1);
local header2 = CreateText(mainsettings, "toggle or global", 0, -20, 0.8, 0.1, 0.1, 1);

local guitext = CreateDropDownText(mainsettings, "GUI Toggle:", 0, -40);
local guitoggle = CreateKeyDropDown(mainsettings, keys, 0, -60, "gui");

local pttext = CreateDropDownText(mainsettings, "Primary Toggle:", 0, -85);
local ptttoggle = CreateKeyDropDown(mainsettings, keys, 0, -105, "primary");

local sttext = CreateDropDownText(mainsettings, "Secondary Toggle:", 0, -130);
local stttoggle = CreateKeyDropDown(mainsettings, keys, 0, -150, "secondary");

local gttext = CreateDropDownText(mainsettings, "Generic Toggle:", 0, -175);
local gttoggle = CreateKeyDropDown(mainsettings, keys, 0, -195, "generic");

local ittext = CreateDropDownText(mainsettings, "Interrupt Toggle:", 0, -220);
local itttoggle = CreateKeyDropDown(mainsettings, keys, 0, -240, "interrupt");

local fttext = CreateDropDownText(mainsettings, "Follow Unit & Toggle:", 0, -265);
local ftedit = CreateEditBox(mainsettings, 0, -282, "follow");
local fttoggle = CreateKeyDropDown(mainsettings, keys, 0, -305, "follow");

local globaltext = CreateDropDownText(mainsettings, "Global variable:", 0, -330);
local globaledit = CreateFrame("EditBox", nil, mainsettings);
globaledit:SetHeight(20)
globaledit:SetWidth(124);
globaledit:SetPoint("TOP", mainsettings, 0, -348)
globaledit:SetFontObject("GameFontHighlight");
globaledit:SetAutoFocus(false);
globaledit:SetJustifyH("CENTER");
globaledit:SetJustifyV("CENTER");
globaledit:EnableMouse(true);
globaledit:SetBackdrop({
	bgFile = "Interface/Buttons/WHITE8X8",
	edgeFile = "Interface/Buttons/WHITE8X8",
	edgeSize = 1,
});
globaledit:SetBackdropColor(0,0,0,0.5);
globaledit:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.5);
globaledit:SetScript("OnEnterPressed", function(self)
	ni.vars.global = self:GetText() or "";
	self:ClearFocus();
end);
globaledit:SetScript("OnEscapePressed", function(self)
	self:SetText(ni.vars.global or "");
	self:ClearFocus();
end);
globaledit:SetText(ni.vars.global or "");
globaledit:Show();

local reloadbutton = CreateFrame("BUTTON", nil, mainsettings, "UIPanelButtonTemplate");
reloadbutton:SetWidth(62);
reloadbutton:SetHeight(22);
reloadbutton:SetText("Reload");
reloadbutton:SetPoint("BOTTOMLEFT", mainsettings, 28, 5);
reloadbutton:SetAlpha(1);
reloadbutton:SetScript("OnClick", function()
	ReloadUI();
end);

local consolebutton = CreateFrame("BUTTON", nil, mainsettings, "UIPanelButtonTemplate");
consolebutton:SetWidth(62);
consolebutton:SetHeight(22);
consolebutton:SetText("Console");
consolebutton:SetPoint("BOTTOMRIGHT", mainsettings, -28, 5);
consolebutton:SetAlpha(1);
consolebutton:SetScript("OnClick", function()
	ni.functions.toggleconsole();
end);

--Rotation Settings drop downs
local mods = {
	"None",
	"Left Alt",
	"Left Control",
	"Left Shift",
	"Right Alt",
	"Right Control",
	"Right Shift"
}
local latency_name = ni.utils.GenerateRandomName();
local slider = CreateFrame("Slider", latency_name, settings, "OptionsSliderTemplate");
slider:SetOrientation("HORIZONTAL");
slider:SetHeight(15);
slider:SetWidth(175);
slider:SetPoint("TOP", settings, 0, -20);
slider:SetMinMaxValues(20, 2000);
slider:SetValueStep(5);
slider:SetValue(ni.vars.latency);
_G[latency_name.."Low"]:SetText(20);
_G[latency_name.."High"]:SetText(2000);
_G[latency_name.."Text"]:SetText("Latency ("..ni.vars.latency.." ms)");
slider:SetScript("OnValueChanged", function(self, value)
	_G[latency_name.."Text"]:SetText("Latency ("..value.." ms)");	
	ni.vars.latency = value;
end);

local aoetext = CreateDropDownText(settings, "Area of Effect Toggle:", 0, -40);
local aoedropdown = CreateKeyDropDown(settings, mods, 0, -60, "aoe");

local pausetext = CreateDropDownText(settings, "Pause Rotation Modifier:", 0, -85);
local pausedropdown = CreateKeyDropDown(settings, mods, 0, -105, "pause");

local cdtext = CreateDropDownText(settings, "CD Toggle:", 0, -130);
local cddropdown = CreateKeyDropDown(settings, mods, 0, -150, "cd");

local customtext = CreateDropDownText(settings, "Custom Toggle:", 0, -175);
local customdropdown = CreateKeyDropDown(settings, mods, 0, -195, "custom");

local mttext = CreateDropDownText(settings, "Main Tank Override:", 0, -220);
local ftedit = CreateEditBox(settings, 0, -238, "mainTank");

local ottext = CreateDropDownText(settings, "Off Tank Override:", 0, -258);
local otedit = CreateEditBox(settings, 0, -276, "offTank");

local mmb_name = ni.utils.GenerateRandomName();
main_ui.minimap_icon = CreateFrame("Button", mmb_name, Minimap);
local mm = main_ui.minimap_icon;
mm:SetHeight(25);
mm:SetWidth(25);
mm:SetFrameStrata("MEDIUM");
mm:SetMovable(true);
mm:SetUserPlaced(true);
main_ui.minimap_toggle = function(bool)
	if bool then
		mm:SetNormalTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up.blp");
		mm:SetPushedTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down.blp");
	else
		mm:SetNormalTexture("Interface\\BUTTONS\\UI-GroupLoot-Coin-Up.blp");
		mm:SetPushedTexture("Interface\\BUTTONS\\UI-GroupLoot-Coin-Down.blp");
	end
end
main_ui.minimap_toggle(ni.vars.profiles.enabled or ni.vars.profiles.genericenabled);
mm:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-Background.blp");
mm:SetPoint("CENTER", ni.vars.ui.icon.x, ni.vars.ui.icon.y);
mm:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		if main_ui.main:IsShown() then
			main_ui.main:Hide();
		else
			main_ui.main:Show();
		end
	elseif button == "RightButton" then
		self:SetScript("OnUpdate", moveIcon);
	end
end);
mm:SetScript("OnMouseUp", function(self)
	self:SetScript("OnUpdate", nil);
end);

local function SetClick(key, frame, button)
	if key == "None" or key == nil then
		return;
	end
	SetBindingClick(key, frame, button);
end

local mainkeys_name = ni.utils.GenerateRandomName();
local mainkeys = CreateFrame("BUTTON", mainkeys_name, UIParent);
SetClick(ni.vars.hotkeys.primary, mainkeys_name, "LeftButton");
SetClick(ni.vars.hotkeys.secondary, mainkeys_name, "RightButton");
SetClick(ni.vars.hotkeys.generic, mainkeys_name, "MiddleButton");
mainkeys:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		ni.toggleprofile(ni.vars.profiles.primary);
		main_ui.minimap_toggle(ni.vars.profiles.enabled or ni.vars.profiles.genericenabled);
	elseif button == "RightButton" then
		ni.toggleprofile(ni.vars.profiles.secondary);
		main_ui.minimap_toggle(ni.vars.profiles.enabled or ni.vars.profiles.genericenabled);
	elseif button == "MiddleButton" then
		ni.togglegeneric(ni.vars.profiles.generic);
		main_ui.minimap_toggle(ni.vars.profiles.enabled or ni.vars.profiles.genericenabled);
	end
end);
mainkeys:Show();
local secondkeys_name = ni.utils.GenerateRandomName();
local secondkeys = CreateFrame("BUTTON", secondkeys_name, UIParent);
SetClick(ni.vars.hotkeys.interrupt, secondkeys_name, "LeftButton");
SetClick(ni.vars.hotkeys.follow, secondkeys_name, "RightButton");
SetClick(ni.vars.hotkeys.gui, secondkeys_name, "MiddleButton");
secondkeys:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		ni.vars.profiles.interrupt = not ni.vars.profiles.interrupt;
		ni.showintstatus();
	elseif button == "RightButton" then
		ni.vars.units.followEnabled = not ni.vars.units.followEnabled;
		ni.updatefollow(ni.vars.units.followEnabled);
	elseif button == "MiddleButton" then
		if main_ui.main:IsShown() then
			main_ui.main:Hide();
		else
			main_ui.main:Show();
		end
	end
end);
secondkeys:Show();

return main_ui;