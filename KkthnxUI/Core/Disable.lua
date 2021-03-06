local K, C, L, _ = unpack(select(2, ...))

-- Prevent users config errors
if C.error.black == true and C.error.white == true then
	C.error.white = false
end

if C.error.combat == true then
	C.error.black = false
	C.error.white = false
end

-- Auto-overwrite script config is X addon is found
if IsAddOnLoaded("gUI4_Minimap") or IsAddOnLoaded("SexyMap") or IsAddOnLoaded("wMinimap") then
	C.minimap.enable = false
end

if IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("RazerNaga") or IsAddOnLoaded("gUI4_ActionBars") then
	C.actionbar.enable = false
end

if IsAddOnLoaded("Mapster") then
	C.map.exploremap = false
	C.map.fogofwar = false
	C.map.mapbosscount = false
end

if IsAddOnLoaded("Prat-3.0") or IsAddOnLoaded("Chatter") or IsAddOnLoaded("gUI4_Chat") then
	C.chat.enable = false
end

if IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("bTooltip") or IsAddOnLoaded("PhoenixTooltip") or IsAddOnLoaded("Icetip") or IsAddOnLoaded("gUI4_Tooltip") or IsAddOnLoaded("rTooltip") then
	C.tooltip.enable = false
end

if IsAddOnLoaded("MikScrollingBattleText") or IsAddOnLoaded("Parrot") or IsAddOnLoaded("xCT") or IsAddOnLoaded("sct") then
	C.combattext.enable = false
end

if IsAddOnLoaded("GnomishVendorShrinker") or IsAddOnLoaded("AlreadyKnown") then
	C.misc.alreadyknown = false
end

if IsAddOnLoaded("Clique") or IsAddOnLoaded("sBinder") then
	C.misc.clickcast = false
end

if IsAddOnLoaded("ChatSounds") then
	C.chat.whisp_sound = false
end