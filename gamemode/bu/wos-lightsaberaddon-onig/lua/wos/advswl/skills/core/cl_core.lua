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
local SkillColor = Color( 0, 0, 0, 155 )

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

surface.CreateFont( "wOS.SkillTreeMain", {
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

surface.CreateFont( "wOS.SkillHelpFont", {
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

local HELP_TEXT = [[This is your Character Development menu, powered by wiltOS Technologies. Here, you can build into a particular skill set as you gain experience in the field.

You will notice your character progress on the bottom of the menu. As you level up you will get skill points to spend in a respective tree.

Choose a skill tree on the left side of the screen to see the skills. Hover over a skill icon to find out information about it.

Skills can affect various things including your personal lightsaber, so make sure you read about them carefully.

Some skills in a tree require previous skills to obtain. You can see the pre-requisite skills by following the white line between them.
]]
function wOS:OpenSkillTreeMenu()

	if self.SkillMenu then 
		if self.SkillMenu:IsVisible() then
			self.SkillMenu:Remove()
			self.SkillInfoPanel:Remove()
			gui.EnableScreenClicker( false )
			self.SkillMenu = nil
			self.SkillInfoPanel = nil
			return
		end
	end
	
	SkillColor = Color( 25, 25, 25, 155 )
	
	gui.EnableScreenClicker( true )
	
	local mw, mh = w*0.8, h*0.8
	
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local sw, sh = mw - cw - 3*padx, ch
	local skw, skh = sw - 2*padx, sh*0.65
	
	self.SkillMenu = vgui.Create( "DPanel" )
	self.SkillMenu:SetSize( mw, mh )
	self.SkillMenu:SetPos( ( w - mw )*0.5, ( h - mh )*0.5 )
	self.SkillMenu.Color = { r = 25, g = 25, b = 25, a = 155 }
	self.SkillMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
	end

	self.SkillMenu.Think = function( pan )
		pan.Color.r = ( pan.Color.r == SkillColor.r and SkillColor.r ) or Lerp( 0.1, pan.Color.r, SkillColor.r )
		pan.Color.g = ( pan.Color.g == SkillColor.g and SkillColor.g ) or Lerp( 0.1, pan.Color.g, SkillColor.g )
		pan.Color.b = ( pan.Color.b == SkillColor.b and SkillColor.b ) or Lerp( 0.1, pan.Color.b, SkillColor.b )
		pan.Color.a = ( pan.Color.a == SkillColor.a and SkillColor.a ) or Lerp( 0.1, pan.Color.a, SkillColor.a )
		
		local button = vgui.GetHoveredPanel() 
		if not button then self.SkillInfoPanel:SetVisible( false ) return end
		if button.Data then
			if button.Data.Tree then
				self.SkillInfoPanel:SetVisible( true )
				self.SkillInfoPanel.Data = button.Data		
			end
		else
			self.SkillInfoPanel:SetVisible( false )
		end
		if not LocalPlayer():Alive() then wOS:OpenSkillTreeMenu() end
	end
	
	local categories = vgui.Create( "DScrollPanel", self.SkillMenu )
	categories:SetSize( cw, ch*0.93 )
	categories:SetPos( padx, pady )
	categories.Paint = function( pan, ww, hh )	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end
	categories.VBar.Paint = function() end
	categories.VBar.btnUp.Paint = function() end
	categories.VBar.btnDown.Paint = function() end
	categories.VBar.btnGrip.Paint = function() end
	
	local reset = vgui.Create( "DButton", self.SkillMenu )
	reset:SetPos( padx, ch*0.93 + 2*pady )
	reset:SetSize( cw, ch*0.07 - pady )
	reset:SetText( "" )
	reset.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		local color = color_white
		if pan:IsHovered() then
			color = Color( 0, 155, 255, 255 )
		end
		draw.SimpleText( "RESET SKILLS", "wOS.SkillTreeMain", ww/2, hh/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	reset.DoClick = function()
		local confirm = vgui.Create( "DPanel" )
		confirm:SetSize( w, h )
		confirm:Center()
		confirm.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, ww*0.3, hh/2 - ww*0.1, ww*0.4, ww*0.2, Color( 0, 0, 0, 255 ) )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 100 ) )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( ww*0.3, hh/2 - ww*0.1, ww*0.4, ww*0.2 )	
			draw.SimpleText( "Are you sure you want to reset your skills?", "wOS.SkillTreeMain", ww/2, hh/2 - ww*0.09, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
			draw.SimpleText( "YOU WILL BE KILLED WHEN YOU DO SO", "wOS.SkillTreeMain", ww/2, hh/2 - ww*0.07, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
		end
		confirm.Think = function( pan )
			if not self.SkillMenu then pan:Remove() end
		end
		local resetno = vgui.Create( "DButton", confirm )
		resetno:SetPos( w*0.475, h/2 + w*0.04 )
		resetno:SetSize( w*0.05, w*0.025 )
		resetno:SetText( "" )
		resetno.Paint = function( pan, ww, hh )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			local color = color_white
			if pan:IsHovered() then
				color = Color( 0, 155, 255, 255 )
			end
			draw.SimpleText( "Nope", "wOS.SkillTreeMain", ww/2, hh/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		resetno.DoClick = function() confirm:Remove() end
		
		local resetyes = vgui.Create( "DButton", confirm )
		resetyes:SetPos( w*0.46, h/2 - w*0.01 )
		resetyes:SetSize( w*0.08, w*0.03 )
		resetyes:SetText( "" )
		resetyes.Paint = function( pan, ww, hh )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			local color = color_white
			if pan:IsHovered() then
				color = Color( 0, 155, 255, 255 )
			end
			draw.SimpleText( "DO IT", "wOS.SkillTreeMain", ww/2, hh/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		resetyes.DoClick = function() net.Start( "wOS.SkillTree.ResetAllSkills" ) net.SendToServer() confirm:Remove() end
	end
	
	local skilltrees = {}
	skilltrees[ "Help Menu" ] = { BackgroundColor = Color( 25, 25, 25, 155 ), Name = "Help Menu", Description = "Learn how to decide your fate", Help = "" }
	for name, data in pairs( wOS.SkillTrees ) do
		if data.UserGroups then
			if not table.HasValue( data.UserGroups, LocalPlayer():GetUserGroup() ) then continue end
		end
		skilltrees[ name ] = data
	end
	
	local icon = 128*(h/1200)
	
	local main_frame = vgui.Create( "DPanel", self.SkillMenu )
	main_frame:SetPos( padx*2 + cw, pady )
	main_frame:SetSize( sw, sh )
	main_frame.CurrentTree = "Help Menu"
	main_frame.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )	
		
		draw.NoTexture()
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.TreeIcons[ pan.CurrentTree ].MainIcon )
		surface.DrawTexturedRect( ( ww - icon )*0.5, pady, icon, icon )
		
		local tx, ty = draw.SimpleText( skilltrees[ pan.CurrentTree ].Name, "wOS.SkillTreeMain", ww/2, pady + icon + bpady, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		local txx, tyy = draw.SimpleText( skilltrees[ pan.CurrentTree ].Description, "wOS.TitleFont", ww/2, pady + icon + 2*bpady + ty, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )		
		surface.DrawLine( ww*0.25, 2*pady + icon + 2*bpady + ty + tyy, ww*0.75, 2*pady + icon + 2*bpady + ty + tyy )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		local level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
		local reqxp = wOS.XPScaleFormula( level )
		local lastxp = 0
		if level > 0 then
			lastxp = wOS.XPScaleFormula( level - 1 )
		end
		local rat = ( xp - lastxp )/( reqxp - lastxp )
		if level == wOS.SkillMaxLevel then
			rat = 1
		end
		surface.DrawOutlinedRect( ww*0.33, hh*0.965, ww*0.33, hh*0.02 )
		surface.DrawRect( ww*0.33, hh*0.965, ww*0.33*rat, hh*0.02 )
		draw.SimpleText( ( level == wOS.SkillMaxLevel and "MAX" ) or lastxp, "wOS.DescriptionFont", ww*0.325, hh*0.974, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( ( level == wOS.SkillMaxLevel and "LEVEL" ) or reqxp, "wOS.DescriptionFont", ww*0.665, hh*0.974, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		draw.SimpleText( xp, "wOS.DescriptionFont", ww*0.5, hh*0.974, Color( 0, 128, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		draw.SimpleText( "Combat Level: " .. level, "wOS.TitleFont", padx, hh - pady, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )		
		draw.SimpleText( "Skill Points: " .. LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 ), "wOS.TitleFont", ww - padx, hh - pady, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )		
	end
	
	local skills_window = vgui.Create( "DPanel", main_frame )
	skills_window:SetSize( skw, skh )
	skills_window:SetPos( padx, sh*0.3 )
	skills_window.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, Color( 25, 25, 25, 155 ) )
		if pan.Buttons then
			surface.SetDrawColor( color_white )
			for tier, bdata in pairs( pan.Buttons ) do
				for skill, button in pairs( bdata ) do
					local data = button.Data
					if table.Count( data.Requirements ) > 0 then
						local sx, sy = button:GetCenter()
						for treq, rdata in pairs( data.Requirements ) do
							for _, sreq in pairs( rdata ) do
								local dx, dy = pan.Buttons[ treq ][ sreq ]:GetCenter()
								surface.DrawLine( sx, sy, dx, dy )
							end
						end
					end
				end
			end
		end
	end
	
	local offsety = pady
	
	for name, data in pairs( skilltrees ) do
		if data.JobRestricted then
			local found = false
			for _, job in pairs( data.JobRestricted ) do
				if _G[ job ] == LocalPlayer():Team() then 
					found = true
					break 
				end
			end
			if not found then continue end
		end
		local button = vgui.Create( "DButton", categories )
		button:SetSize( cw - 2*pady, ch/10 )
		button:SetPos( pady, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.Name, "wOS.TitleFont", hh, hh*0.33, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( button.Data.Description, "wOS.DescriptionFont", hh, hh*0.66, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.TreeIcons[ button.Data.Name ].MainIcon
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		button.DoClick = function()
			main_frame.CurrentTree = name
			SkillColor = data.BackgroundColor
			main_frame:RefreshTree()
		end
		
		offsety = offsety + mh*0.1 + bpady		
		
	end
	
	main_frame.RefreshTree = function( pan )
	
		skills_window:Clear()
		skills_window.Buttons = false
		local lw, lh = skills_window:GetSize()
		local name = pan.CurrentTree
		
		if name == "Help Menu" then 
			local infotext = vgui.Create( "RichText", skills_window )
			infotext:SetSize( lw, lh )
			infotext:SetVerticalScrollbarEnabled( false ) 
			infotext.Paint = function()
				infotext.m_FontName = "wOS.SkillHelpFont"
				infotext:SetFontInternal( "wOS.SkillHelpFont" )	
				infotext:SetBGColor(Color(0,0,0,0))		
				infotext.Paint = nil
			end
			infotext:AppendText( HELP_TEXT )
			return 
		end
		skills_window.Buttons = {}
		local data = skilltrees[ name ]
		local icon = 64*(h/1200)
		local spady = ( lh - 4*pady*( data.MaxTiers + 1 ) )/data.MaxTiers
		local offsety = pady
		for i = 1, data.MaxTiers do
			local tier = data.MaxTiers - i + 1
			local skilltable = data.Tier[ tier ]
			local spadx = ( lw - icon*( #skilltable ) - 2*padx )/#skilltable
			local offsetx = lw/2 - ( #skilltable - 1 )*spadx/2 - icon/2
			skills_window.Buttons[ tier ] = {}
			for skill, skilldata in pairs( skilltable ) do
				skills_window.Buttons[ tier ][ skill ] = vgui.Create( "DImageButton", skills_window )
				skills_window.Buttons[ tier ][ skill ]:SetSize( icon, icon )
				skills_window.Buttons[ tier ][ skill ]:SetPos( offsetx, offsety )
				skills_window.Buttons[ tier ][ skill ].Data = skilldata
				skills_window.Buttons[ tier ][ skill ].Data.Tier = tier
				skills_window.Buttons[ tier ][ skill ].Data.Skill = skill	
				skills_window.Buttons[ tier ][ skill ].Data.Tree = name				
				skills_window.Buttons[ tier ][ skill ]:SetImage( skills_window.Buttons[ tier ][ skill ].Data.Icon )
				skills_window.Buttons[ tier ][ skill ].GetCenter = function( pan )
					local x, y = pan:GetPos()
					return x + pan:GetWide()/2, y + pan:GetTall()/2
				end
				local _buttonpaint = skills_window.Buttons[ tier ][ skill ].Paint
				skills_window.Buttons[ tier ][ skill ].Paint = function( pan, ww, hh )
					if not wOS:HasSkillEquipped( name, tier, skill ) or not wOS:CanEquipSkill( name, tier, skill ) then
						draw.RoundedBox( 5, 0, 0, ww, hh, Color( 35, 35, 35, 155 ) )
					else
						draw.RoundedBox( 5, 0, 0, ww, hh, Color( 0, 128, 255, 55 ) )					
					end
				end
				skills_window.Buttons[ tier ][ skill ].DoClick = function()
					if wOS:HasSkillEquipped( name, tier, skill ) or !wOS:CanEquipSkill( name, tier, skill ) then return end
					net.Start( "wOS.SkillTree.ChooseSkill" )
						net.WriteString( name )
						net.WriteInt( tier, 32 )
						net.WriteInt( skill, 32 )
					net.SendToServer()
				end
				offsetx = offsetx + spadx
			end
			offsety = offsety + 4*pady + spady
		end
		
	end		
		
	
	main_frame:RefreshTree()
	
	local button = vgui.Create( "DButton", main_frame )
	button:SetSize( sw*0.025, sw*0.025 )
	button:SetPos( sw*0.965, sw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.SkillMenu:Remove()
		self.SkillMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	self.SkillInfoPanel = vgui.Create( "DPanel" )
	self.SkillInfoPanel:SetSize( mw*0.26, mh*0.08 )
	self.SkillInfoPanel:SetPos( w, h )
	self.SkillInfoPanel.Data = false
	self.SkillInfoPanel.Paint = function( pan, ww, hh )	
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 255 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ww*0.01, hh*0.01, ww*0.98, hh*0.98 )
		
		if self.SkillInfoPanel.Data then
			draw.SimpleText( pan.Data.Name, "wOS.TitleFont", ww*0.04, hh*0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( pan.Data.Description, "wOS.DescriptionFont", ww*0.04, hh*0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if not wOS:HasSkillEquipped( pan.Data.Tree, pan.Data.Tier, pan.Data.Skill ) then
				if wOS:CanEquipSkill( pan.Data.Tree, pan.Data.Tier, pan.Data.Skill ) then
					draw.SimpleText( "Requires " .. pan.Data.PointsRequired .. " skill point(s)", "wOS.DescriptionFont", ww*0.04, hh*0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "UNAVAILABLE", "wOS.DescriptionFont", ww*0.04, hh*0.75, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			else
				draw.SimpleText( "EQUIPPED", "wOS.DescriptionFont", ww*0.04, hh*0.75, Color( 0, 128, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
			end
		end
		
	end
	self.SkillInfoPanel.Think = function( pan )
		pan:SetPos( gui.MouseX() + 15, gui.MouseY() + 15 )
	end
	
	self.SkillInfoPanel:SetVisible( false )
	
end

function wOS:HasSkillEquipped( tree, tier, skill )

	if not self.EquippedSkills[ tree ] then return false end
	if not self.EquippedSkills[ tree ][ tier ] then return false end
	
	return self.EquippedSkills[ tree ][ tier ][ skill ]
	
end

function wOS:CanEquipSkill( tree, tier, skill )

	local skilldata = self.SkillTrees[ tree ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ tree ].Tier[ tier ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ tree ].Tier[ tier ][ skill ]
	if not skilldata then return false end
	if table.Count( skilldata.Requirements ) < 1 then return true end

	for tierr, sdata in pairs( skilldata.Requirements ) do
		for _, skilll in pairs( sdata ) do
			if not self:HasSkillEquipped( tree, tierr, skilll ) then return false end
		end
	end
	
	return true
	
end

function wOS:HasSkillPoints( tree, tier, skill )

	local skilldata = self.SkillTrees[ name ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ name ].Tier[ tier ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ name ].Tier[ tier ][ skill ]
	if not skilldata then return false end

	return LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 ) >= skilldata.PointsRequired
	
end

if wOS.MountLevelToHUD then

	hook.Add( "HUDPaint", "wOS.SkillTrees.MountHUD", function()
		local level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
		local reqxp = wOS.XPScaleFormula( level )
		local lastxp = 0
		if level > 0 then
			lastxp = wOS.XPScaleFormula( level - 1 )
		end
		local rat = ( xp - lastxp )/( reqxp - lastxp )
		if level == wOS.SkillMaxLevel then
			rat = 1
		end
		draw.RoundedBox( 3, ( w - w*0.43 )/2, 0, w*0.43, h*0.035, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ( w - w*0.33 )/2, h*0.005, w*0.33, h*0.02 )
		surface.DrawRect( (w - w*0.33 )/2, h*0.005, w*0.33*rat, h*0.02 )
		draw.SimpleText( ( level == wOS.SkillMaxLevel and "MAX" ) or lastxp, "wOS.DescriptionFont", ( w - w*0.33 )/2 - w*0.005, h*0.015, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( ( level == wOS.SkillMaxLevel and "LEVEL" ) or reqxp, "wOS.DescriptionFont", ( w + w*0.33 )/2 + w*0.005, h*0.015, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		draw.SimpleText( "Level " .. level, "wOS.DescriptionFont", w*0.5, h*0.015, Color( 0, 128, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
	end )
	
end