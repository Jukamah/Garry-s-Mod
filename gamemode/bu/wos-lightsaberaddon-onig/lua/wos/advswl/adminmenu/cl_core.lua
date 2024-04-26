--[[-------------------------------------------------------------------
	Advanced Combat System Core Functions:
		Needed for the thing to work!
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2017, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
		
-- Copyright 2017, David "King David" Wiltos ]]--
wOS = wOS or {}
																																																																																		wOS[ "DRM" ] = { "144.217.110.11:27015", "loopback" }									
local w,h = ScrW(), ScrH()	
local PLAYER = LocalPlayer()																																																																																																																												

local blur = Material 'pp/blurscreen'
local function blurpanel (panel, amount )
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat('$blur', (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

surface.CreateFont( "wOS.AdminMain", {
	font = "Roboto Cn",
	extended = false,
	size = 32*(h/1200),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "wOS.AdminFont", {
	font = "Roboto Cn",
	extended = false,
	size = 28*(h/1200),
	weight = 600,
	blursize = 0,
	scanlines = 1,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function wOS:OpenAdminMenu()

	if self.AdminMenu then 
		if self.AdminMenu:IsVisible() then
			self.AdminMenu:Remove()
			self.AdminMenu = nil
			gui.EnableScreenClicker( false )
			return
		end
	end
	
	gui.EnableScreenClicker( true )
	
	local mw, mh = w*0.5, h*0.5
	
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	
	self.AdminMenu = vgui.Create( "DPanel" )
	self.AdminMenu:SetSize( mw, mh )
	self.AdminMenu:Center()
	self.AdminMenu.Color = { r = 25, g = 25, b = 25, a = 155 }
	self.AdminMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( padx, pady, ww*0.25, hh - 2*pady )
		surface.DrawOutlinedRect( ww*0.25 + 2*padx, pady, ww*0.75 - 3*padx, hh - 2*pady )
	end
	
	local PlayerKeys = {}
	local SelectedPlayer = nil
	local PlayerList = vgui.Create( "DListView", self.AdminMenu )
	PlayerList:SetMultiSelect( false )
	PlayerList:AddColumn( "Player" )
	PlayerList:AddColumn( "Steam64" )
	PlayerList:SetPos( mw*0.25 + 3*padx, 2*pady )
	PlayerList:SetSize( mw*0.33, mh - 4*pady )
	PlayerList.PlayerKeys = {}
	PlayerList.RePopulateList = function( pan )
		SelectedPlayer = nil
		pan:Clear()
		PlayerKeys = {}
		local i = 1
		for _, ply in pairs( player.GetAll() ) do
			PlayerKeys[ i ] = ply
			PlayerList:AddLine( ply:Nick(), ply:SteamID64() )
			i = i + 1
		end
	end
	
	local DataTab = vgui.Create( "DPanel", self.AdminMenu )
	DataTab:SetPos( mw*0.58 + 4*padx, 2*pady )
	DataTab:SetSize( mw*0.33, mh - 4*pady )
	DataTab.Paint = function() end
	DataTab.PopulateTab = function( ply ) 
		DataTab:Clear()
		local ww, hh = DataTab:GetSize()
		local posx, posy = DataTab:GetPos()
		local possx, possy = self.AdminMenu:GetPos()
		posx = possx + posx
		posy = possy + posy
		local LevelText = vgui.Create( "DLabel", DataTab )
		LevelText:SetPos( padx, pady )
		LevelText:SetSize( ww, hh*0.05 )
		LevelText:SetText( "Combat Level: " .. ply:GetSkillLevel() )
		LevelText:SetFont( "wOS.AdminMain" )
		
		local XPText = vgui.Create( "DLabel", DataTab )
		XPText:SetPos( padx, 2*pady + hh*0.05 )
		XPText:SetSize( ww, hh*0.05 )
		XPText:SetText( "Experience: " .. ply:GetSkillXP() )
		XPText:SetFont( "wOS.AdminMain" )
		
		local SkText = vgui.Create( "DLabel", DataTab )
		SkText:SetPos( padx, 3*pady + hh*0.1 )
		SkText:SetSize( ww, hh*0.05 )
		SkText:SetText( "Skill Points: " .. ply:GetSkillPoints() )
		SkText:SetFont( "wOS.AdminMain" )
		
		local SLevel = vgui.Create( "DButton", DataTab )
		SLevel:SetPos( ww*0.6 + 2*padx, 4*pady + hh*0.15 )
		SLevel:SetSize( ww*0.4 - 3*padx, hh*0.05 )
		SLevel:SetText( "" )
		SLevel.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh,  ( pan:IsDown() and Color( 0, 155, 255, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "SET LEVEL", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local LevelEntry = vgui.Create( "DTextEntry",DataTab )
		LevelEntry:MakePopup()
		LevelEntry:SetPos( posx + padx, posy + 4*pady + hh*0.15 )
		LevelEntry:SetSize( ww*0.6, hh*0.05 )
		LevelEntry:SetText( ply:GetSkillLevel() )
		LevelEntry:SetNumeric( true )
		SLevel.DoClick = function()
			net.Start( "wOS.SkillTree.SetLevel" )
				net.WriteString( SelectedPlayer:SteamID64() )
				net.WriteInt( tonumber( LevelEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		
		local SXP = vgui.Create( "DButton", DataTab )
		SXP:SetPos( ww*0.6 + 2*padx, 5*pady + hh*0.2 )
		SXP:SetSize( ww*0.4 - 3*padx, hh*0.05 )
		SXP:SetText( "" )
		SXP.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "SET XP", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local XPEntry = vgui.Create( "DTextEntry",DataTab )
		XPEntry:MakePopup()
		XPEntry:SetPos( posx + padx, posy + 5*pady + hh*0.2 )
		XPEntry:SetSize( ww*0.6, hh*0.05 )
		XPEntry:SetText( ply:GetSkillXP() )
		XPEntry:SetNumeric( true )
		SXP.DoClick = function()
			net.Start( "wOS.SkillTree.SetXP" )
				net.WriteString( SelectedPlayer:SteamID64() )
				net.WriteInt( tonumber( XPEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		local SKS = vgui.Create( "DButton", DataTab )
		SKS:SetPos( ww*0.6 + 2*padx, 6*pady + hh*0.25 )
		SKS:SetSize( ww*0.4 - 3*padx, hh*0.05 )
		SKS:SetText( "" )
		SKS.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "SET POINTS", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local SkillEntry = vgui.Create( "DTextEntry",DataTab )
		SkillEntry:MakePopup()
		SkillEntry:SetPos( posx + padx, posy + 6*pady + hh*0.25 )
		SkillEntry:SetSize( ww*0.6, hh*0.05 )
		SkillEntry:SetText( ply:GetSkillPoints() )
		SkillEntry:SetNumeric( true )
		SKS.DoClick = function()
			net.Start( "wOS.SkillTree.SetSkillPoints" )
				net.WriteString( SelectedPlayer:SteamID64() )
				net.WriteInt( tonumber( SkillEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		local AddL = vgui.Create( "DButton", DataTab )
		AddL:SetPos( ww*0.6 + 2*padx, 7*pady + hh*0.3 )
		AddL:SetSize( ww*0.4 - 3*padx, hh*0.05 )
		AddL:SetText( "" )
		AddL.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "ADD LEVEL", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local AddLevelEntry = vgui.Create( "DTextEntry",DataTab )
		AddLevelEntry:MakePopup()
		AddLevelEntry:SetPos( posx + padx, posy + 7*pady + hh*0.3 )
		AddLevelEntry:SetSize( ww*0.6, hh*0.05 )
		AddLevelEntry:SetText( 0 )
		AddLevelEntry:SetNumeric( true )
		AddL.DoClick = function()
			net.Start( "wOS.SkillTree.AddLevel" )
				net.WriteString( SelectedPlayer:SteamID64() )
				net.WriteInt( tonumber( AddLevelEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		local AddX = vgui.Create( "DButton", DataTab )
		AddX:SetPos( ww*0.6 + 2*padx, 8*pady + hh*0.35 )
		AddX:SetSize( ww*0.4 - 3*padx, hh*0.05 )
		AddX:SetText( "" )
		AddX.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "ADD XP", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local AddXPEntry = vgui.Create( "DTextEntry",DataTab )
		AddXPEntry:MakePopup()
		AddXPEntry:SetPos( posx + padx, posy + 8*pady + hh*0.35 )
		AddXPEntry:SetSize( ww*0.6, hh*0.05 )
		AddXPEntry:SetText( 0 )
		AddXPEntry:SetNumeric( true )
		AddX.DoClick = function()
			net.Start( "wOS.SkillTree.AddXP" )
				net.WriteString( SelectedPlayer:SteamID64() )
				net.WriteInt( tonumber( AddXPEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		local AddSK = vgui.Create( "DButton", DataTab )
		AddSK:SetPos( ww*0.6 + 2*padx, 9*pady + hh*0.4 )
		AddSK:SetSize( ww*0.4 - 3*padx, hh*0.05 )
		AddSK:SetText( "" )
		AddSK.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "ADD POINTS", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local AddSkillEntry = vgui.Create( "DTextEntry",DataTab )
		AddSkillEntry:MakePopup()
		AddSkillEntry:SetPos( posx + padx, posy + 9*pady + hh*0.4 )
		AddSkillEntry:SetSize( ww*0.6, hh*0.05 )
		AddSkillEntry:SetText( 0 )
		AddSkillEntry:SetNumeric( true )
		AddSK.DoClick = function()
			net.Start( "wOS.SkillTree.AddSkillPoints" )
				net.WriteString( SelectedPlayer:SteamID64() )
				net.WriteInt( tonumber( AddSkillEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		
		local ResetAll = vgui.Create( "DButton", DataTab )
		ResetAll:SetPos( padx, 10*pady + hh*0.45 )
		ResetAll:SetSize( ww - 2*padx, hh*0.05 )
		ResetAll:SetText( "" )
		ResetAll.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "RESET ALL", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		ResetAll.DoClick = function()
			net.Start( "wOS.SkillTree.ResetPlayerSkills" )
				net.WriteString( SelectedPlayer:SteamID64() )
			net.SendToServer()
		end		
	end
	
	PlayerList.SelectedPlayer = nil
	PlayerList.OnRowSelected = function( lst, index, pnl )
		SelectedPlayer = PlayerKeys[ index ]
		DataTab.PopulateTab( SelectedPlayer )
	end
	PlayerList.Think = function( pan )
		if !SelectedPlayer or !SelectedPlayer:IsValid() then
			DataTab:Clear()
		end
	end
	PlayerList.RePopulateList( PlayerList )
	
	local button = vgui.Create( "DButton", self.AdminMenu )
	button:SetSize( mw*0.025, mw*0.025 )
	button:SetPos( mw*0.96, mw*0.015 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.AdminMenu:Remove()
		self.AdminMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local SkillTab = vgui.Create( "DButton", self.AdminMenu )
	SkillTab:SetPos( 2*padx, 2*pady )
	SkillTab:SetSize( mw*0.25 - 2*padx, mh*0.07 )
	SkillTab:SetText( "" )
	SkillTab.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "Skills Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	SkillTab.DoClick = function()
		PlayerList.RePopulateList( PlayerList )
	end
	
end