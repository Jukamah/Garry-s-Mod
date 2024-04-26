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

surface.CreateFont( "wOS.TitleFont", {
	font = "Roboto Cn",
	extended = false,
	size = 24*(h/1200),
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

surface.CreateFont( "wOS.DescriptionFont",{
	font = "Roboto Cn",
	extended = false,
	size = 18*(h/1200),
	weight = 500,
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

concommand.Add( "wos_togglefirstperson", function( ply, cmd, args )
	if ( !IsValid( ply:GetActiveWeapon() ) || !ply:GetActiveWeapon().IsLightsaber ) then return end
	local wep = ply:GetActiveWeapon()
	if not wep.FirstPerson then 
		wep.FirstPerson = true 
		return 
	else
		wep.FirstPerson = false
	end
end )					

wOS.ShouldDrawLightsaberLight = CreateConVar( "wos_alcs_drawsaberlight", "1", FCVAR_ARCHIVE )

function wOS:OpenFormMenu( dual )

	if self.FormMenu then return end
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	
	
	local forms = {}
	local group = LocalPlayer():GetUserGroup()
	
	if wep.UseForms then
		for fr, _ in pairs( wep.UseForms ) do
			table.insert( forms, fr )
		end
	else
		if table.HasValue( wOS.AllAccessForms, group ) then
			if dual then
				for form, _ in pairs( wOS.DualForms ) do
					table.insert( forms, form )
				end		
			else
				for form, _ in pairs( wOS.Forms ) do
					table.insert( forms, form )
				end
			end	
		else
			if dual then
				for form, _ in pairs( wOS.DualForms ) do
					if wOS.DualForms[ form ][ group ] then
						table.insert( forms, form )
					end
				end		
			else
				for form, _ in pairs( wOS.Forms ) do
					if wOS.Forms[ form ][ group ] then
						table.insert( forms, form )
					end
				end
			end
		end
	end
	
	if table.Count( forms ) < 1 then return end
	
	gui.EnableScreenClicker( true )
	self.FormMenu = vgui.Create( "DPanel" )
	self.FormMenu:SetSize( w*0.33, h*0.5 )
	self.FormMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.FormMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Form Select Menu", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.FormMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.FormMenu )
	formlist:SetPos( fw*0.05, fh*0.1 )
	formlist:SetSize( mw, mh )
	formlist.Paint = function( pan, ww, hh ) 
	end
	formlist.VBar.Paint = function() end
	formlist.VBar.btnUp.Paint = function() end
	formlist.VBar.btnDown.Paint = function() end
	formlist.VBar.btnGrip.Paint = function() end

	local offsety = 0
	local pady = mh*0.01
	
	local button = vgui.Create( "DButton", self.FormMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.FormMenu:Remove()
		self.FormMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.FormMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	
	for _, form in pairs( forms ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Form = form
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Form, "wOS.TitleFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		button.DoClick = function()
			self.FormMenu:Remove()
			self.FormMenu = nil
			net.Start( "wOS.SendFormSelect" )
			net.WriteString( button.Form )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		
		offsety = offsety + mh*0.1 + pady
		
	end
	
end

function wOS:OpenForceMenu()

	if self.ForceMenu then return end	
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	local powers = wep:GetActiveForcePowers()
	if table.Count( powers ) < 1 then return end
	
	gui.EnableScreenClicker( true )
	self.ForceMenu = vgui.Create( "DPanel" )
	self.ForceMenu:SetSize( w*0.33, h*0.5 )
	self.ForceMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.ForceMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Force Select Menu", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.ForceMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.ForceMenu )
	formlist:SetPos( fw*0.05, fh*0.1 )
	formlist:SetSize( mw, mh )
	formlist.Paint = function( pan, ww, hh ) 
	end
	formlist.VBar.Paint = function() end
	formlist.VBar.btnUp.Paint = function() end
	formlist.VBar.btnDown.Paint = function() end
	formlist.VBar.btnGrip.Paint = function() end
	
	local offsety = 0
	local pady = mh*0.01
	
	local button = vgui.Create( "DButton", self.ForceMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.ForceMenu:Remove()
		self.ForceMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.ForceMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	for key, data in pairs( powers ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.name, "wOS.TitleFont", hh, hh*0.025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( button.Data.description, "wOS.DescriptionFont", hh, hh*0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.ForceIcons[ button.Data.name ]
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		button.DoClick = function()
			self.ForceMenu:Remove()
			self.ForceMenu = nil
			net.Start( "wOS.SendForceSelect" )
			net.WriteInt( key, 32 )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		
		offsety = offsety + mh*0.1 + pady
		
	end
	
end

function wOS:OpenDevestatorMenu()

	if self.DevestatorMenu then return end	
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	local powers = wep:GetActiveDevestators()
	if table.Count( powers ) < 1 then return end
	
	gui.EnableScreenClicker( true )
	self.DevestatorMenu = vgui.Create( "DPanel" )
	self.DevestatorMenu:SetSize( w*0.33, h*0.5 )
	self.DevestatorMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.DevestatorMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Devestators Menu", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.DevestatorMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.DevestatorMenu )
	formlist:SetPos( fw*0.05, fh*0.1 )
	formlist:SetSize( mw, mh )
	formlist.Paint = function( pan, ww, hh ) 
	end
	formlist.VBar.Paint = function() end
	formlist.VBar.btnUp.Paint = function() end
	formlist.VBar.btnDown.Paint = function() end
	formlist.VBar.btnGrip.Paint = function() end
	
	local offsety = 0
	local pady = mh*0.01
	
	local button = vgui.Create( "DButton", self.DevestatorMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.DevestatorMenu:Remove()
		self.DevestatorMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.DevestatorMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	for key, data in pairs( powers ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.name, "wOS.TitleFont", hh, hh*0.025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( button.Data.description, "wOS.DescriptionFont", hh, hh*0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.DevestatorIcons[ button.Data.name ]
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		button.DoClick = function()
			self.DevestatorMenu:Remove()
			self.DevestatorMenu = nil
			net.Start( "wOS.SendDevestatorSelect" )
			net.WriteInt( key, 32 )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		
		offsety = offsety + mh*0.1 + pady
		
	end
	
end