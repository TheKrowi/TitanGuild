----------------------------------------------------------------------
-- TitanGuildMenu.lua
-- code for generating the cascading right-click menus
----------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)

----------------------------------------------------------------------
-- TitanPanelRightClickMenu_PrepareGuildMenu()
----------------------------------------------------------------------
function TitanPanelRightClickMenu_PrepareGuildMenu()
	local NumGuild = 0;
	local guild_name = "";
	local guild_rank = "";
	local guild_rankIndex = "";
	local guild_level = "";
	local guild_class = "";
	local guild_zone = "";
	local guild_note = "";
	local guild_officernote = "";
	local guild_online = "";
	local guild_status = "";
	local guildIndex;



	-- Level 2 -----------------------------------------
	if ( _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 2 ) then
		if (_G["L_UIDROPDOWNMENU_MENU_VALUE"]) then
			-- chat
			if (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_CHAT_TEXT) then
				TitanPanelRightClickMenu_AddTitle(_G["L_UIDROPDOWNMENU_MENU_VALUE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				-- open guild chat
				info = {};
				info.text = TITAN_GUILD_GUILD_CHAT;
				info.func = function() TitanPanelGuildButton_OpenGuildChat(); end;
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				-- open officer chat only for officers
				local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
				-- assuming if the player can view the officer note, then they can do /o chat
				if ( C_GuildInfo.CanViewOfficerNote() ) then
					info = {};
					info.text = TITAN_GUILD_GUILD_OFFICER_CHAT;
					info.func = function() TitanPanelGuildButton_OpenGuildOfficerChat(); end;
					L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				end
			-- sort
			elseif (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_SORT_TEXT) then
				-- sort options
				TitanPanelRightClickMenu_AddTitle(_G["L_UIDROPDOWNMENU_MENU_VALUE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				local choiceIndex;
				for choiceIndex = 1, table.getn(sortChoicesValues) do
					info = {};
					info.text = sortChoicesLabels[choiceIndex];
					info.value = string.lower(sortChoicesValues[choiceIndex]);
					info.func = function() TitanPanelGuildButton_SetSortByValue(string.lower(sortChoicesValues[choiceIndex])); end;
					--info.checked = TitanGetVar(TITAN_GUILD_ID, "SortByValue");
					L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
				end
				TitanPanelRightClickMenu_AddCommand(TITAN_GUILD_MENU_HIDE, TITAN_GUILD_ID, TITAN_GUILD_BUTTON_CLOSEMENU, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
			elseif (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_TOOLTIP_TEXT) then
				-- tooltip options
				TitanPanelRightClickMenu_AddTitle(_G["L_UIDROPDOWNMENU_MENU_VALUE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
				local choiceIndex;
				for choiceIndex = 1, table.getn(sortChoicesValues) do
					info = {};
					info.text = sortChoicesLabels[choiceIndex];
					info.value = sortChoicesValues[choiceIndex];
					info.func = function() TitanPanelGuildButton_SetTooltipChoice(sortChoicesValues[choiceIndex]); end;
					info.checked = TitanGetVar(TITAN_GUILD_ID, "ShowTooltip"..sortChoicesValues[choiceIndex]);
					info.keepShownOnClick = 1;
					L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
				end
				info = {};
				info.text = TITAN_GUILD_MENU_DISPLAYSIZE:format( TitanGetVar(TITAN_GUILD_ID, "TooltipSize") );
				info.value = TITAN_GUILD_MENU_TOOLTIPSIZE;
				info.hasArrow = 1;
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				TitanPanelRightClickMenu_AddCommand(TITAN_GUILD_MENU_HIDE, TITAN_GUILD_ID, TITAN_GUILD_BUTTON_CLOSEMENU, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			elseif (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_FILTER_TEXT) then
				-- filter options
				TitanPanelRightClickMenu_AddTitle(_G["L_UIDROPDOWNMENU_MENU_VALUE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				-- lvl
				info = {};
				info.text = TITAN_GUILD_MENU_FILTER_MYLEVEL;
				info.func = function() TitanPanelGuildButton_ToggleFilterMyLevel(); end;
				info.checked = TitanGetVar(TITAN_GUILD_ID, "FilterMyLevel");
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				-- zone
				info = {};
				info.text = TITAN_GUILD_MENU_FILTER_MYZONE;
				info.func = function() TitanPanelGuildButton_ToggleFilterMyZone(); end;
				info.checked = TitanGetVar(TITAN_GUILD_ID, "FilterMyZone");
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				-- class
				info = {};
				info.text = TITAN_GUILD_MENU_FILTER_CLASS;
				info.hasArrow = 1;
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);												
				TitanPanelRightClickMenu_AddCommand(TITAN_GUILD_MENU_HIDE, TITAN_GUILD_ID, TITAN_GUILD_BUTTON_CLOSEMENU, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
			elseif (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_CONFIGURE_UPDATE_TIME) then
				-- update options
				TitanPanelRightClickMenu_AddTitle(_G["L_UIDROPDOWNMENU_MENU_VALUE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				local choiceIndex;
				for choiceIndex = 1, table.getn(updateTimeOptions) do
					info = {};
					info.text = updateTimeLabels[choiceIndex];
					info.value = updateTimeOptions[choiceIndex];
					info.func = function() TitanPanelGuildButton_SetRosterUpdateTime(updateTimeOptions[choiceIndex]); end;
					if (updateTimeOptions[choiceIndex] == TitanGetVar(TITAN_GUILD_ID, "RosterUpdateTime")) then
						info.checked = 1;
					end
					L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
				end
				-- toggle roster updates
				info = {};
				info.text = TITAN_GUILD_MENU_DISABLE_UPDATE_TEXT;
				info.func = function() TitanPanelGuildButton_ToggleRosterUpdates(); end;
				info.checked = TitanGetVar(TITAN_GUILD_ID, "DisableRosterUpdates");
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				-- toggle mouse-over updates
				info = {};
				info.text = TITAN_GUILD_MENU_DISABLE_MOUSEOVER_UPDATE;
				info.func = function() TitanPanelGuildButton_ToggleMouseOverUpdates(); end;
				info.checked = TitanGetVar(TITAN_GUILD_ID, "DisableMouseOverUpdates");
				L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);					
				-- hide							
				TitanPanelRightClickMenu_AddCommand(TITAN_GUILD_MENU_HIDE, TITAN_GUILD_ID, TITAN_GUILD_BUTTON_CLOSEMENU, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			-- player submenus
			else
				if (TitanGetVar(TITAN_GUILD_ID, "ShowAdvancedMenus")) then
					-- if hovering over a different rank, then refresh paging
					if (priorAdvMenuValue ~= _G["L_UIDROPDOWNMENU_MENU_VALUE"]) then
						TitanPanelGuildButton_InitPaging();
						priorAdvMenuValue = _G["L_UIDROPDOWNMENU_MENU_VALUE"];
					end
					-- generate lvl 2 player lists based on rank
					TitanPanelRightClickMenu_AddTitle(GuildControlGetRankName(_G["L_UIDROPDOWNMENU_MENU_VALUE"]), _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
					TitanPanelGuildButton_ComputeAdvancedPages(table.getn(masterTable[_G["L_UIDROPDOWNMENU_MENU_VALUE"]].members));
					TitanPanelGuildButton_BuildBackwardPageControl();
					for numMember = currIndex, maxIndex do
						if (masterTable[_G["L_UIDROPDOWNMENU_MENU_VALUE"]].members[numMember]) then
							info = {};
							info.text = masterTable[_G["L_UIDROPDOWNMENU_MENU_VALUE"]].members[numMember];
							info.hasArrow = 1;
							L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
						end				
					end
					TitanPanelGuildButton_BuildForwardPageControl();
				else
					-- build interaction menus for simple player list
					TitanPanelGuildButton_BuildInteractionMenu();
				end
			end
		end
		return
		-- End Level 2 -------------------------------------
	elseif (_G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 3) then
		-- Level 3 ------------------------------------------
		if (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_FILTER_CLASS) then
			TitanPanelGuildButton_BuildClassFilterMenu();
		else
			if (_G["L_UIDROPDOWNMENU_MENU_VALUE"] == TITAN_GUILD_MENU_TOOLTIPSIZE) then
				local start = 5
				local size = TitanGetVar(TITAN_GUILD_ID, "TooltipSize");
				for i = 1, 11 do
					local index = start * i;
					info = {};
					info.text = index;
					info.value = index;
					if (size == index) then info.checked = 1; end
					info.func = TitanPanelGuildButton_SetTooltipSize;
					L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
				end
			else
				TitanPanelGuildButton_BuildInteractionMenu();
			end
		end
		return									
		-- End Level 3 --------------------------------------
	end

	-- add a nice title for those that are not in a guild
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_GUILD_ID].menuText);

	if (IsInGuild()) then
		-- get guild members
		NumGuild = GetNumGuildMembers();
		-- build menus based on rank
		-- ADVANCED ---------------------------------------------			
		if (TitanGetVar(TITAN_GUILD_ID, "ShowAdvancedMenus")) then
			if (table.getn(masterTable) <= 0) then
				TitanPanelRightClickMenu_AddSpacer();
				TitanPanelRightClickMenu_AddTitle(TITAN_GUILD_MENU_PLEASE_WAIT_TEXT);
			else
				for rankMenuIndex = 1, table.getn(masterTable) do
					if (table.getn(masterTable[rankMenuIndex].members) > 0) then
						info = {};
						info.text = TitanPanelGuildButton_ColorRankNameText(rankMenuIndex-1, masterTable[rankMenuIndex].rank);
						info.hasArrow = 1;
						info.value = rankMenuIndex;
						L_UIDropDownMenu_AddButton(info);
					end						
				end
			end
		else			
			-- build the lvl 1 simple menus
			-- SIMPLE ---------------------------------------------
			TitanPanelGuildButton_BuildBackwardPageControl();
			for guildIndex = currIndex, maxIndex do
				if (masterTableSimple[guildIndex]) then
					info = {};
					info.text = TitanPanelGuildButton_ColorRankNameText(masterTableSimple[guildIndex].rankIndex, masterTableSimple[guildIndex].name);
					info.hasArrow = 1;
					info.value = masterTableSimple[guildIndex].name;
					info.func = function() TitanPanelGuildButton_GuildWhisper(masterTableSimple[guildIndex].name) end;
					L_UIDropDownMenu_AddButton(info);
				end				
			end
			TitanPanelGuildButton_BuildForwardPageControl();
		end
	
		if (TitanGetVar(TITAN_GUILD_ID, "ShowMenuOptions")) then
			TitanPanelRightClickMenu_AddSpacer();

			-- toggle the menu options for more room
			TitanPanelRightClickMenu_AddCommand(TITAN_GUILD_MENU_HIDE_OPTIONS_TEXT, TITAN_GUILD_ID, TITAN_GUILD_BUTTON_SHOWOPTIONS);				
			TitanPanelRightClickMenu_AddSpacer();

			-- toggle the advanced menus
			info = {};
			info.text = TITAN_GUILD_MENU_SHOWADVANCED_TEXT;
			info.func = function() TitanPanelGuildButton_ToggleAdvancedMenus(); end;
			info.checked = TitanGetVar(TITAN_GUILD_ID, "ShowAdvancedMenus");
			L_UIDropDownMenu_AddButton(info);		
	
			-- open guild chat
			info = {};
			info.text = TITAN_GUILD_MENU_CHAT_TEXT;
			info.hasArrow = 1;
			L_UIDropDownMenu_AddButton(info);
				
			-- open sort submenu
			info = {};
			info.text = TITAN_GUILD_MENU_SORT_TEXT;
			info.hasArrow = 1;
			L_UIDropDownMenu_AddButton(info);
				
			-- open tooltip submenu
			info = {};
			info.text = TITAN_GUILD_MENU_TOOLTIP_TEXT;
			info.hasArrow = 1;
			L_UIDropDownMenu_AddButton(info);
				
			-- open filter submenu
			info = {};
			info.text = TITAN_GUILD_MENU_FILTER_TEXT;
			info.hasArrow = 1;
			L_UIDropDownMenu_AddButton(info);
			
			-- configure roster updates
			info = {};
			info.text = TITAN_GUILD_MENU_CONFIGURE_UPDATE_TIME;
			info.hasArrow = 1;
			L_UIDropDownMenu_AddButton(info);									
		else
			-- toggle the menu options for more room
			TitanPanelRightClickMenu_AddSpacer();
			TitanPanelRightClickMenu_AddCommand(TITAN_GUILD_MENU_SHOW_OPTIONS_TEXT, TITAN_GUILD_ID, TITAN_GUILD_BUTTON_SHOWOPTIONS);
		end
	end
	-- add default menu options
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_GUILD_ID);	
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_GUILD_ID);
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_GUILD_ID, TITAN_PANEL_MENU_FUNC_HIDE);	
end

----------------------------------------------------------------------
--  TitanPanelGuildButton_BuildInteractionMenu()
----------------------------------------------------------------------
function TitanPanelGuildButton_BuildInteractionMenu()
	TitanPanelRightClickMenu_AddTitle(_G["L_UIDROPDOWNMENU_MENU_VALUE"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
	-- whisper
	info = {};
	info.text = TITAN_GUILD_MENU_ADVANCED_WHISPER_TEXT;
	info.value = _G["L_UIDROPDOWNMENU_MENU_VALUE"];
	info.func = function() TitanPanelGuildButton_GuildWhisper(_G["L_UIDROPDOWNMENU_MENU_VALUE"]) end;
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);			
	-- invite
	info = {};
	info.text = TITAN_GUILD_MENU_ADVANCED_INVITE_TEXT;
	info.value = _G["L_UIDROPDOWNMENU_MENU_VALUE"];
	info.func = function() TitanPanelGuildButton_InviteToGroup(_G["L_UIDROPDOWNMENU_MENU_VALUE"]) end;
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
	-- who
	info = {};
	info.text = TITAN_GUILD_MENU_ADVANCED_WHO_TEXT;
	info.value = _G["L_UIDROPDOWNMENU_MENU_VALUE"];
	info.func = function() TitanPanelGuildButton_SendWhoRequest(_G["L_UIDROPDOWNMENU_MENU_VALUE"]) end;
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
	-- friend
	info = {};
	info.text = TITAN_GUILD_MENU_ADVANCED_FRIEND_TEXT;
	info.value = _G["L_UIDROPDOWNMENU_MENU_VALUE"];
	info.func = function() TitanPanelGuildButton_AddFriend(_G["L_UIDROPDOWNMENU_MENU_VALUE"]) end;
	L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);	
end
