TrackPlayers = {}

TrackPlayers = { "STEAM_0:1:47057013" }

AllowedUserGroups = { "superadmin" }

Test = { "as", "asdsd"}

local Panel
local PanelListTitle
local PanelList
local PanelPlayers
local PanelListText = ""
local PanelListTextIndex = ""

local CurSel = { "Name", "SteamID", "Total Time" }

function InitPanel()
	Panel = vgui.Create("DFrame")
	Panel:SetTitle("V - Player Tracking")
	Panel:SetSize(750, 395)
	Panel:Center()
	Panel:MakePopup()
	Panel.Paint = function()
		draw.RoundedBox(8, 0, 0, Panel:GetWide(), Panel:GetTall(), Color(100, 100, 255, 175))
	end
	Panel:SetDeleteOnClose(false)
	
	PanelListTitle = vgui.Create("DLabel", Panel)
	PanelListTitle:SetPos(40, 25)
	PanelListTitle:SetFont("DermaLarge")
	PanelListTitle:SetTextColor(Color(255, 255, 255))
	PanelListTitle:SetText("Currently Tracked Players")
	PanelListTitle:SizeToContents()
	
	PanelList = vgui.Create("DScrollPanel", Panel)
	PanelList:SetSize(360, 330)
	PanelList:SetPos(5, 60)
	PanelList.Paint = function()
		draw.RoundedBox(8, 0, 0, PanelList:GetWide(), PanelList:GetTall(), Color(125, 125, 225, 255))
	end
	
	for k, v in pairs(player.GetAll()) do
		local row = sql.QueryRow("SELECT istracking FROM vptit WHERE id = " .. v:UniqueID() .. ";")
		
		if row then
			local PanelPlayer = vgui.Create("DButton", PanelList)
			PanelPlayer:SetSize(350, 30)
			PanelPlayer:SetPos(5, (i * 35 - 30))
			PanelPlayer.Paint = function()
				draw.RoundedBox(8, 0, 0, PanelPlayer:GetWide(), PanelPlayer:GetTall(), Color(150, 150, 255))
			end
		
			local CurText = ""
			for k, v in pairs(player.GetAll()) do
				if TrackPlayers[i] == v:SteamID() then
					local sID = v:SteamID()
					local ply = v:Nick()
					PanelPlayer:SetText(ply.. " (".. sID.. "): Total Time (".. timeToStr(v:GetPTTotalTime()).. ")")
				end
			end
			PanelPlayer.DoClick = function()
				
			end
			PanelList:AddItem(PanelPlayer)
		
			PanelPlayer:SetText(v:Nick().. " (".. v:SteamID().. "): Total Time (".. timeToStr(v:GetPTTotalTime()).. ")")
		end
	end
	
	PanelPlayers = vgui.Create("DScrollPanel", Panel)
	PanelPlayers:SetSize(360, 330)
	PanelPlayers:SetPos(385, 60)
	PanelPlayers.Paint = function()
		draw.RoundedBox(8, 0, 0, PanelPlayers:GetWide(), PanelPlayers:GetTall(), Color(125, 125, 225, 255))
	end
	
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and v:IsPlayer() then
			local i = #player.GetAll()
		
			local CurText = (v:Nick().. " (".. v:SteamID().. ")")
			
			local PanelPlayerButton = vgui.Create("DButton", PanelPlayers)
			PanelPlayerButton:SetSize(350, 30)
			PanelPlayerButton:SetPos(5, (i * 35 - 30))
			PanelPlayerButton.Paint = function()
				draw.RoundedBox(8, 0, 0, PanelPlayerButton:GetWide(), PanelPlayerButton:GetTall(), Color(150, 150, 255))
			end
			PanelPlayerButton:SetText(CurText)
			
			PanelPlayerButton.DoClick = function()
				sql.Query("UPDATE vptit SET istracking = 1 WHERE id = ".. v:UniqueID() .. ";")
				
				local row = sql.QueryRow("SELECT sid, istracking FROM vptit WHERE id = " .. v:UniqueID() .. ";")
				print(row)
			end
		end
	end
end
concommand.Add("v-pt-panel", function(ply, cmd, args)
	if IsValid(ply) and ply:IsPlayer() then
		if table.HasValue(AllowedUserGroups, ply:GetUserGroup()) then
			InitPanel()
		else
			if table.HasValue(TrackPlayers, ply:SteamID()) then
				InitPanel()
			else
				ply:PrintMessage(HUD_PRINTTALK, "You Do Not Have The Correct Permissions To Do This!")
			end
		end
	end
end)