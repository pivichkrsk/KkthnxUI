local K, C, L, _ = unpack(select(2, ...))
if C.skins.dbm ~= true then return end

local forcebosshealthclasscolor = false		-- Forces BossHealth to be classcolored. Not recommended.
local croprwicons = true					-- Crops blizz shitty borders from icons in RaidWarning messages
local rwiconsize = 12						-- RaidWarning icon size. Works only if croprwicons = true
local backdrop = {
	bgFile = C.media.texture,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("DBM-Core") then
		local function SkinBars(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					bar.ApplyStyle = function()
						local frame = bar.frame
						local tbar = _G[frame:GetName().."Bar"]
						local spark = _G[frame:GetName().."BarSpark"]
						local texture = _G[frame:GetName().."BarTexture"]
						local icon1 = _G[frame:GetName().."BarIcon1"]
						local icon2 = _G[frame:GetName().."BarIcon2"]
						local name = _G[frame:GetName().."BarName"]
						local timer = _G[frame:GetName().."BarTimer"]
						
						if (icon1.overlay) then
							icon1.overlay = _G[icon1.overlay:GetName()]
						else
							icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
							icon1.overlay:SetWidth(23)
							icon1.overlay:SetHeight(23)
							icon1.overlay:SetFrameStrata("BACKGROUND")
							icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -5, -2)
							CreateStyle(icon1.overlay, 2)
						end
						
						if (icon2.overlay) then
							icon2.overlay = _G[icon2.overlay:GetName()]
						else
							icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
							icon2.overlay:SetWidth(23)
							icon2.overlay:SetHeight(23)
							icon2.overlay:SetFrameStrata("BACKGROUND")
							icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 5, -2)
							CreateStyle(icon2.overlay, 2)
						end
						
						if bar.color then
							tbar:SetStatusBarColor(0.1, 0.1, 0.1)
							tbar:SetBackdrop(backdrop)
							tbar:SetBackdropColor(0.1, 0.1, 0.1, 0.15)
						else
							tbar:SetStatusBarColor(0.1, 0.1, 0.1)
							tbar:SetBackdrop(backdrop)
							tbar:SetBackdropColor(0.1, 0.1, 0.1, 0.15)
						end
						
						if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
						if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end
						
						frame:SetScale(1)
						if not frame.styled then
							frame:SetHeight(23)
							CreateStyle(frame, 2)
							frame.styled = true
						end
						
						if not spark.killed then
							spark:SetAlpha(0)
							spark:SetTexture(nil)
							spark.killed = true
						end
						
						if not icon1.styled then
							icon1:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon1:ClearAllPoints()
							icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
							icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)
							icon1.styled = true
						end
						
						if not icon2.styled then
							icon2:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon2:ClearAllPoints()
							icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
							icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)
							icon2.styled = true
						end
						
						if not texture.styled then
							texture:SetTexture(C.media.texture)
							texture.styled = true
						end
						
						if not tbar.styled then
							tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
							tbar.styled = true
						end
						
						if not name.styled then
							name:ClearAllPoints()
							name:SetPoint("LEFT", frame, "LEFT", 4, 0)
							name:SetWidth(180)
							name:SetHeight(8)
							name:SetFont(C.font.basic_font, C.font.basic_font_size, C.font.basic_font_style)
							name:SetShadowOffset(0, 0, 0, 0)
							name:SetJustifyH("LEFT")
							name.SetFont = K.Dummy
							name.styled = true
						end
						
						if not timer.styled then
							timer:ClearAllPoints()
							timer:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
							timer:SetFont(C.font.basic_font, C.font.basic_font_size, C.font.basic_font_style)
							timer:SetShadowOffset(0, 0, 0, 0)
							timer:SetJustifyH("RIGHT")
							timer.SetFont = K.Dummy
							timer.styled = true
						end
						
						if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
						if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
						tbar:SetAlpha(1)
						frame:SetAlpha(1)
						texture:SetAlpha(1)
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
					bar:ApplyStyle()
				end
			end
		end
		
		local SkinBossTitle = function()
			local anchor = DBMBossHealthDropdown:GetParent()
			if not anchor.styled then
				local header = {anchor:GetRegions()}
				if header[1]:IsObjectType("FontString") then
					header[1]:SetFont(C.font.basic_font, C.font.basic_font_size, C.font.basic_font_style)
					header[1]:SetShadowOffset(0, 0, 0, 0)
					header[1]:SetTextColor(1, 1, 1, 1)
					anchor.styled = true	
				end
				header = nil
			end
			anchor = nil
		end
		
		local SkinBoss = function()
			local count = 1
			while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
				local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
				local background = _G[bar:GetName().."BarBorder"]
				local progress = _G[bar:GetName().."Bar"]
				local name = _G[bar:GetName().."BarName"]
				local timer = _G[bar:GetName().."BarTimer"]
				local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]
				
				if (count == 1) then
					local _, anch, _ , _, _ = bar:GetPoint()
					bar:ClearAllPoints()
					if DBM_AllSavedOptions["Default"].HealthFrameGrowUp then
						bar:SetPoint("BOTTOM", anch, "TOP", 0, 3)
					else
						bar:SetPoint("TOP", anch, "BOTTOM", 0, -3)
					end
				else
					bar:ClearAllPoints()
					if DBM_AllSavedOptions["Default"].HealthFrameGrowUp then
						bar:SetPoint("BOTTOMLEFT", prev, "TOPLEFT", 0, 3)
					else
						bar:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -3)
					end
				end
				
				if not bar.styled then
					bar:SetScale(1)
					bar:SetHeight(19)
					CreateStyle(bar, 2)
					background:SetNormalTexture(nil)
					bar.styled = true
				end	
				
				if not progress.styled then
					progress:SetStatusBarTexture(C.media.texture)
					progress:SetBackdrop(backdrop)
					progress:SetBackdropColor(r,g,b,1)
					if forcebosshealthclasscolor then
						local tslu = 0
						progress:SetStatusBarColor(r,g,b,1)
						progress:HookScript("OnUpdate", function(self, elapsed)
							tslu = tslu+ elapsed
							if tslu > 0.025 then
								self:SetStatusBarColor(r,g,b,1)
								tslu = 0
							end
						end)
					end
					progress.styled = true
				end
				progress:ClearAllPoints()
				progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
				progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
				
				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", bar, "LEFT", 4, 0)
					name:SetFont(C.font.basic_font, C.font.basic_font_size, C.font.basic_font_style)
					name:SetShadowOffset(0, 0, 0, 0)
					name:SetJustifyH("LEFT")
					name.styled = true
				end
				
				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
					timer:SetFont(C.font.basic_font, C.font.basic_font_size, C.font.basic_font_style)
					timer:SetShadowOffset(0, 0, 0, 0)
					timer:SetJustifyH("RIGHT")
					timer.styled = true
				end
				count = count + 1
			end
		end
		
		hooksecurefunc(DBT, "CreateBar", SkinBars)
		hooksecurefunc(DBM.BossHealth, "Show", SkinBossTitle)
		hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
		hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss)
		
		local firstRange = true
		hooksecurefunc(DBM.RangeCheck, "Show", function()
			if firstRange then
				DBMRangeCheck:SetBackdrop(nil)
				local bd = CreateFrame("Frame", nil, DBMRangeCheckRadar)
				bd:SetPoint("TOPLEFT")
				bd:SetPoint("BOTTOMRIGHT")
				bd:SetFrameLevel(0)
				bd:SetFrameStrata(DBMRangeCheckRadar:GetFrameStrata())
				bd:SetBackdropColor(.05,.05,.05, .9)
				bd:SetBackdrop(backdrop)
				bd:SetBackdropColor(.08,.08,.08, .9)
				
				firstRange = false
			end
		end)
		
		if croprwicons then
			local replace = string.gsub
			local old = RaidNotice_AddMessage
			RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString=replace(textString,"(:12:12)",":"..rwiconsize..":"..rwiconsize..":0:0:64:64:5:59:5:59")
				end
				return old(noticeFrame, textString, colorInfo)
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	DBM settings(by ALZA and help from Affli)
----------------------------------------------------------------------------------------
function K.UploadDBM()
	if IsAddOnLoaded("DBM-Core") then
		DBM_UseDualProfile = false
		DBM_AllSavedOptions["Default"].Enabled = true
		DBM_AllSavedOptions["Default"].ShowMinimapButton = C.skins.minimap_buttons and true or false
		DBM_AllSavedOptions["Default"].WarningIconLeft = false
		DBM_AllSavedOptions["Default"].WarningIconRight = false
		DBM_AllSavedOptions["Default"].WarningColors = {
			{["b"] = K.Color.b, ["g"] = K.Color.g, ["r"] = K.Color.r,},
			{["b"] = K.Color.b, ["g"] = K.Color.g, ["r"] = K.Color.r,},
			{["b"] = K.Color.b, ["g"] = K.Color.g, ["r"] = K.Color.r,},
			{["b"] = K.Color.b, ["g"] = K.Color.g, ["r"] = K.Color.r,},
		}
		DBM_AllSavedOptions["Default"].HealthFrameGrowUp = false
		DBM_AllSavedOptions["Default"].HealthFrameWidth = 218
		DBM_AllSavedOptions["Default"].HPFrameX = 100
		DBM_AllSavedOptions["Default"].HPFramePoint = "LEFT"
		DBM_AllSavedOptions["Default"].RangeFrameX = 244
		DBM_AllSavedOptions["Default"].RangeFramePoint = "LEFT"
		DBM_AllSavedOptions["Default"].ShowSpecialWarnings = true
		DBM_AllSavedOptions["Default"].SpecialWarningFont = C.font.basic_font
		DBM_AllSavedOptions["Default"].SpecialWarningFontSize = 50
		DBM_AllSavedOptions["Default"].SpecialWarningX = 0
		DBM_AllSavedOptions["Default"].SpecialWarningY = 75

		DBT_AllPersistentOptions["Default"]["DBM"].StartColorR = K.Color.r
		DBT_AllPersistentOptions["Default"]["DBM"].StartColorG = K.Color.g
		DBT_AllPersistentOptions["Default"]["DBM"].StartColorB = K.Color.b
		DBT_AllPersistentOptions["Default"]["DBM"].EndColorR = K.Color.r
		DBT_AllPersistentOptions["Default"]["DBM"].EndColorG = K.Color.g
		DBT_AllPersistentOptions["Default"]["DBM"].EndColorB = K.Color.b
		DBT_AllPersistentOptions["Default"]["DBM"].Scale = 1
		DBT_AllPersistentOptions["Default"]["DBM"].HugeScale = 1
		DBT_AllPersistentOptions["Default"]["DBM"].BarXOffset = 0
		DBT_AllPersistentOptions["Default"]["DBM"].BarYOffset = 7
		DBT_AllPersistentOptions["Default"]["DBM"].Font = C.font.basic_font
		DBT_AllPersistentOptions["Default"]["DBM"].FontSize = C.font.basic_font_size
		DBT_AllPersistentOptions["Default"]["DBM"].Width = 189
		DBT_AllPersistentOptions["Default"]["DBM"].TimerX = -468.500244140625
		DBT_AllPersistentOptions["Default"]["DBM"].TimerPoint = "CENTER"
		DBT_AllPersistentOptions["Default"]["DBM"].FillUpBars = true
		DBT_AllPersistentOptions["Default"]["DBM"].IconLeft = true
		DBT_AllPersistentOptions["Default"]["DBM"].ExpandUpwards = true
		DBT_AllPersistentOptions["Default"]["DBM"].Texture = C.media.texture
		DBT_AllPersistentOptions["Default"]["DBM"].IconRight = false
		DBT_AllPersistentOptions["Default"]["DBM"].HugeBarXOffset = 0
		DBT_AllPersistentOptions["Default"]["DBM"].HugeBarsEnabled = false
		DBT_AllPersistentOptions["Default"]["DBM"].HugeWidth = 189
		DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerX = 6
		DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerPoint = "CENTER"
		DBT_AllPersistentOptions["Default"]["DBM"].HugeBarYOffset = 7

		DBM_AllSavedOptions["Default"].InstalledBars = C.actionbar.enable
	end
end

StaticPopupDialogs.SETTINGS_DBM = {
	text = L_POPUP_SETTINGS_DBM,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() K.UploadDBM() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 5,
}

----------------------------------------------------------------------------------------
--	On logon function
----------------------------------------------------------------------------------------
local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if IsAddOnLoaded("DBM-Core") then
		if DBM_AllSavedOptions["Default"].InstalledBars ~= C.actionbar.enable then
			StaticPopup_Show("SETTINGS_DBM")
		end
	end
end)