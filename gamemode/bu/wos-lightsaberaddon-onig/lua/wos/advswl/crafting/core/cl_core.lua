--[[-------------------------------------------------------------------
	Lightsaber Crafting System:
		If you build it, Sith will come
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

local w,h = ScrW(), ScrH()
local lookingat = nil

language.Add( "wos_primary_saber", "PRIMARY" )
language.Add( "wos_secondary_saber", "SECONDARY" )
language.Add( "wos_primary_blade", "Primary Blade" )
language.Add( "wos_secondary_blade", "Secondary Blade" )
language.Add( "wos_dual_saber", "DUAL" )
language.Add( "wos_option_hilt", "Hilt" )
language.Add( "wos_option_color", "Crystal" )
language.Add( "wos_option_blade", "Blade" )
language.Add( "wos_option_misc", "Energizers" )
language.Add( "wos_advert_wiltos", "Powered by wiltOS Technologies" )
language.Add( "wos_select_primaryhilt", "Set as Primary Hilt" )
language.Add( "wos_select_secondaryhilt", "Set as Secondary Hilt" )
language.Add( "wos_info_bladel", "Blade Length:" )
language.Add( "wos_info_bladew", "Blade Width:" )
language.Add( "wos_info_dark", "Dark Inner Blade" )
language.Add( "wos_info_primcrystal", "Primary Crystal" )
language.Add( "wos_info_seccrystal", "Secondary Crystal" )
language.Add( "wos_info_igniter", "Crystal Activator" )
language.Add( "wos_info_humsound", "Idle Regulator" )
language.Add( "wos_info_swingsound", "Power Vortex Regulator" )
language.Add( "wos_info_blueprints", "Blueprints" )
language.Add( "wos_info_miscitem", "Extensions" )

local centerpoint = wOS.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local LastCamOrigin = vector_origin
local LastCamAng = Angle( 0, 0, 0 )

wOS.CraftingCamera = {}
wOS.CraftingCamera[ "Overview" ] = { origin = centerpoint - Vector( 400, -35, -25 ), angles = Angle( 20.840, -30.501, 0.000 ) }

surface.CreateFont( "wOS.CraftTitles", {
	font = "Roboto Cn",
	extended = false,
	size = 180,
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

surface.CreateFont( "wOS.CraftDescriptions", {
	font = "Roboto Cn",
	extended = false,
	size = 60,
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

surface.CreateFont( "wOS.CraftMinors", {
	font = "Roboto Cn",
	extended = false,
	size = 30,
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

surface.CreateFont( "wOS.ItemTitles", {
	font = "Roboto Cn",
	extended = false,
	size = 360,
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

surface.CreateFont( "wOS.ItemDescriptions", {
	font = "Roboto Cn",
	extended = false,
	size = 90,
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

--local wallMat = Material("models/xqm/lightlinesred_tool")
--local wallMat = Material("phoenix_storms/FuturisticTrackRamp_1-2")
local wallMat = Material( "wos/phoenix_storms/wire/pcb_black", "unlitgeneric" )
--local wallMat = Material("phoenix_storms/Future_vents")

local upButton = Material( "wos/crafting/gui/up.png", "unlitgeneric" )
local downButton = Material( "wos/crafting/gui/down.png", "unlitgeneric" )
local bufferBar = Material( "wos/crafting/gui/buffer.png", "unlitgeneric" )

local ItemTable = {}
ItemTable[ WOSTYPE.CRYSTAL ] = Material( "wos/crafting/items/crystal.png", "unlitgeneric" )
ItemTable[ WOSTYPE.IGNITER ] = Material( "wos/crafting/items/crystal_ignitor.png", "unlitgeneric" )
ItemTable[ WOSTYPE.IDLE ] = Material( "wos/crafting/items/idle_regulator.png", "unlitgeneric" )
ItemTable[ WOSTYPE.VORTEX ] = Material( "wos/crafting/items/power_vortex.png", "unlitgeneric" ) 
ItemTable[ WOSTYPE.HILT ] = Material( "wos/crafting/items/hilt.png", "unlitgeneric" )
ItemTable[ WOSTYPE.BLUEPRINT ] = Material( "wos/crafting/items/blueprint.png", "unlitgeneric" ) 

hook.Add( "PostDrawOpaqueRenderables", "VoidHole", function()
	if !IsValid( wOS.CraftingMenu ) then return end
	if !wOS.CraftingMenu:IsVisible() then return end
	local pos = Vector( centerpoint ) 
	local angle = Angle(0, 0, 0)
    local scale = 200
    local size = 5
    local center = pos - Vector( 0, 0, 200 )
	render.SetMaterial(wallMat)
	render.DrawQuadEasy(center + Vector(0, 0, 400), Vector(0, 0, -1), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, size*scale/2, 100), Vector(0, 1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(size*scale/2, 0, 100), Vector(1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, -size*scale/2, 100), Vector(0, -1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(-size*scale/2, 0, 100), Vector(-1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, 0, 100), Vector(0, 0, 1), size*scale, size*scale, 0, Color(255, 0, 0 ), 0)
	--[[
    render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)

        render.SetStencilReferenceValue(57)
        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilPassOperation(STENCIL_REPLACE)

        cam.Start3D2D(pos, angle, scale)
            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawRect(0, 0, size, size)
        cam.End3D2D()

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        cam.IgnoreZ(true)
            render.SetMaterial(wallMat)
            render.DrawQuadEasy(center - Vector(0, 0, 100), Vector(0, 0, 1), size*scale, size*scale, 0, Color(255, 0, 0), 0)
            render.DrawQuadEasy(center - Vector(0, size*scale/2, 100), Vector(0, 1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
            render.DrawQuadEasy(center - Vector(size*scale/2, 0, 100), Vector(1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)

            render.DrawQuadEasy(center - Vector(0, -size*scale/2, 100), Vector(0, -1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
            render.DrawQuadEasy(center - Vector(-size*scale/2, 0, 100), Vector(-1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
        cam.IgnoreZ(false)
    render.SetStencilEnable(false)
	]]--
	
end )

hook.Add( "PostDrawTranslucentRenderables", "wOS.DrawSaberBladeAnd3D2D", function()

	if lookingat then
		lookingat:Renders()
		lookingat:Render( lookingat.CamPos, lookingat.CamAng, lookingat.Scaling or 0.1 )
	end

	if !IsValid( wOS.CraftingMenu ) then return end
	if !wOS.CraftingMenu:IsVisible() then return end
	if !IsValid( wOS.CraftingMenu.Saber ) then return end

	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0

	for id, t in pairs( wOS.CraftingMenu.Saber:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )
		if ( bladeNum && wOS.CraftingMenu.Saber:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = wOS:FindBladePosAng( bladeNum, false, wOS.CraftingMenu.Saber )
			if not pos then return end
			rb655_RenderBlade_wos( pos, dir, wOS[ wOS.CurrentCraftTable ].UseLength, wOS[ wOS.CurrentCraftTable ].UseLength, wOS[ wOS.CurrentCraftTable ].UseWidth, wOS[ wOS.CurrentCraftTable ].UseColor, wOS[ wOS.CurrentCraftTable ].UseDarkInner == 1, wOS.CraftingMenu.Saber:EntIndex(), false, false, blades, wOS[ wOS.CurrentCraftTable ].CustomSettings )
			bladesFound = true
		end

		if ( quillonNum && wOS.CraftingMenu.Saber:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = wOS:FindBladePosAng( quillonNum, true, wOS.CraftingMenu.Saber )
			if not pos then return end
			rb655_RenderBlade_wos( pos, dir, wOS[ wOS.CurrentCraftTable ].UseLength, wOS[ wOS.CurrentCraftTable ].UseLength, wOS[ wOS.CurrentCraftTable ].UseWidth, wOS[ wOS.CurrentCraftTable ].UseColor, wOS[ wOS.CurrentCraftTable ].UseDarkInner == 1, wOS.CraftingMenu.Saber:EntIndex(), false, true, blades, wOS[ wOS.CurrentCraftTable ].CustomSettings )
		end

	end	
	
	if not bladesFound then
		local pos, dir = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
		rb655_RenderBlade_wos( pos, dir, wOS[ wOS.CurrentCraftTable ].UseLength, wOS[ wOS.CurrentCraftTable ].UseLength, wOS[ wOS.CurrentCraftTable ].UseWidth, wOS[ wOS.CurrentCraftTable ].UseColor, wOS[ wOS.CurrentCraftTable ].UseDarkInner == 1, wOS.CraftingMenu.Saber:EntIndex(), false, false, blades, wOS[ wOS.CurrentCraftTable ].CustomSettings )
	end
	
	for _, frame in ipairs( wOS.CraftingButtons ) do
		frame:Renders()
		frame:Render( frame.CamPos, frame.CamAng, frame.Scaling or 0.1 )
	end
	
	if wOS.blueprint_item then wOS.blueprint_item:Think() end

end )

hook.Add( "CalcView", "wOS.CraftingCamera", function( ply, pos, ang )
	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	if !IsValid( wOS.CraftingMenu ) then return end
	if !wOS.CraftingMenu:IsVisible() then return end
	LastCamOrigin = ( LastCamOrigin == wOS.CraftingCamera[ wOS.CraftingFocus ].origin and wOS.CraftingCamera[ wOS.CraftingFocus ].origin ) or Lerp( FrameTime()*3, LastCamOrigin, wOS.CraftingCamera[ wOS.CraftingFocus ].origin )
	LastCamAng = ( LastCamAng == wOS.CraftingCamera[ wOS.CraftingFocus ].angles and wOS.CraftingCamera[ wOS.CraftingFocus ].angles ) or Lerp( FrameTime()*3, LastCamAng, wOS.CraftingCamera[ wOS.CraftingFocus ].angles )	
	return  { 
				origin = LastCamOrigin,
				angles = LastCamAng,
				drawviewer = false,
		    }
	
end )

wOS.PersonalSaber = table.Copy( wOS.DefaultPersonalSaber )
wOS.SecPersonalSaber = table.Copy( wOS.DefaultSecPersonalSaber )

function wOS:CleanCraftingMenus( button )
	if not button then
		if IsValid( self.CraftingMenu.Saber ) then 
			self.CraftingMenu.Saber:Remove()
		end
		self.CraftingMenu:Remove()
		self.CraftingMenu = nil
		gui.EnableScreenClicker( false )
	end
	if self.blueprint_floor then self.blueprint_floor:Remove() end
	if self.blueprint_item then self.blueprint_item:Remove() end
	self.blueprint_floor = nil
	self.blueprint_item = nil
	self.CraftingButtons = {}
end

function wOS:OpenSaberCrafting()

	if self.CraftingMenu then 
		self:CleanCraftingMenus()
		return
	end
	
	gui.EnableScreenClicker( true )
	
	if !self.PreCraftingMenu then
		wOS.UsingDualLightsaber = false
		self.PreCraftingMenu = vgui.Create( "DPanel" )
		self.PreCraftingMenu:SetSize( w, h )
		self.PreCraftingMenu:Center()
		self.PreCraftingMenu.Paint = function() end
		self.PreCraftingMenu.Think = function()
			if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		end
		
		local PrimarySaber = vgui.Create( "DButton", self.PreCraftingMenu )
		PrimarySaber:SetSize( w*0.12, h*0.05 )
		PrimarySaber:SetPos( w*0.38, h*0.44 )
		PrimarySaber:SetText( "" )
		PrimarySaber.Paint = function( pan, ww, hh )
			surface.SetDrawColor( ( pan:IsHovered() and Color( 0, 166, 255, 255 ) ) or color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 155 ) )
			draw.SimpleText( "Primary Lightsaber", "wOS.CraftMinors", ww/2, hh/2, ( pan:IsHovered() and Color( 0, 166, 255, 255 ) ) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		PrimarySaber.DoClick = function( pan )
			wOS.CurrentInventoryTable = "EquippedItems"
			wOS.CurrentCraftTable = "PersonalSaber"
			wOS.UsingDualLightsaber = false
			wOS:OpenSaberCrafting()
		end		
		
		local SecondarySaber = vgui.Create( "DButton", self.PreCraftingMenu )
		SecondarySaber:SetSize( w*0.12, h*0.05 )
		SecondarySaber:SetPos( w*0.51, h*0.51 )
		SecondarySaber:SetText( "" )
		SecondarySaber.Paint = function( pan, ww, hh )
			surface.SetDrawColor( ( pan:IsHovered() and Color( 0, 166, 255, 255 ) ) or color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 155 ) )
			draw.SimpleText( "Off Hand Lightsaber", "wOS.CraftMinors", ww/2, hh/2, ( pan:IsHovered() and Color( 0, 166, 255, 255 ) ) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		SecondarySaber.DoClick = function( pan )
			wOS.CurrentInventoryTable = "SecEquippedItems"
			wOS.CurrentCraftTable = "SecPersonalSaber"
			wOS.UsingDualLightsaber = true
			wOS:OpenSaberCrafting()
		end		
		return
	else
		self.PreCraftingMenu:Remove()
		self.PreCraftingMenu = nil
	end
	
	if self.InventoryPanel then
		self:ViewInventory()
	end
	
	gui.EnableScreenClicker( true )	
	wOS.PersonalSaber.Hilt = GetConVar( "rb655_lightsaber_model" ):GetString()
	wOS.PersonalSaber.CustomSettings[ "CraftingSaber" ] = true

	self.CraftingFocus = "Overview"
	
	self.CraftingMenu = vgui.Create( "DPanel" )
	self.CraftingMenu:SetSize( 0, 0 )
	self.CraftingMenu.Paint = function( pan, ww, hh )
		--draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
	end 
	
	self:BuildCraftingSaber()
	LastCamOrigin = self.CraftingMenu.Saber:GetPos() + Vector( 0, 0, 50 )
	LastCamAng = Angle( 90, 0, 0 )
	self:RebuildCraftingMenus()
	
end

function wOS:BuildCraftingSaber()
	if !IsValid( self.CraftingMenu ) then return end
	if IsValid( self.CraftingMenu.Saber ) then 
		self.CraftingMenu.Saber:Remove()
	end
	self.CraftingMenu.Saber = ClientsideModel( self[ self.CurrentCraftTable ].UseHilt, RENDERGROUP_BOTH )
	self.CraftingMenu.Saber:SetPos( centerpoint - Vector( 350, -10, 0 ) )
	local ang = self.CraftingMenu.Saber:GetAngles()
	if self[ self.CurrentCraftTable ].UseHilt:find( "maul_saber_staff" ) then
		ang:RotateAroundAxis( ang:Up(), -90 )
	else
		ang:RotateAroundAxis( ang:Up(), 90 )	
	end
	self.CraftingMenu.Saber:SetAngles( ang )
end

function wOS:RebuildCraftingMenus()
	self:CleanCraftingMenus( true )
	self.CraftMenuLibrary[ self.CraftingFocus ]()
end

function wOS:FindBladePosAng( num, side, model )
	
	num = num or 1
	local attachment = model:LookupAttachment( "blade" .. num )
	if ( side ) then
		attachment = model:LookupAttachment( "quillon" .. num )
	end
	
	if ( attachment && attachment > 0 ) then
		local PosAng = model:GetAttachment( attachment )
		return PosAng.Pos, PosAng.Ang:Forward()
	end
	
	local ang = model:GetAngles()
	ang = -1*ang:Forward()
	local pos = model:GetPos() + Vector( 0.6, 0.6, -0.25 )
	
	if num > 1 then
		ang = ang*-1
	end
	
	pos = pos - ang	
		
	return pos, ang
	
end

function wOS:FindHandPosAng( model )

	local attachment = model:LookupBone( "ValveBiped.Bip01_R_Hand" )

	if ( attachment && attachment >= 0 ) then
		local Pos, Ang = model:GetBonePosition( attachment )
		return Pos + Vector( 0, 0, 3 ), -1*Ang:Up()
	end
	
	local ang = model:GetAngles()
	ang = -1*ang:Forward()
	local pos = model:GetPos()
	
	if num > 1 then
		ang = ang*-1
	end
	
	pos = pos - ang	
		
	return pos, ang
	
end

wOS.CraftMenuLibrary = {}

wOS.CraftMenuLibrary[ "Overview" ] = function()
	local spos, sang = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
	local bladecat = tduiw.Create()
	bladecat.SizeX = 10
	bladecat.SizeY = 5
	bladecat.ShouldAcceptInputs = true
	bladecat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Line( 0, 0, 0, -15 + 2*hh )
		pan:Line( 0, -15 + 2*hh, 5, -15 + hh/2 )
		pan:Rect( 5, -15, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		--pan:Text( "Crystal", "wOS.TitleFont", ww/2, hh/2, color_unselected, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local _jp, _pr, _hov = pan:Button( language.GetPhrase( "wos_option_color" ), "wOS.TitleFont", 5, -15, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_option_color" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	bladecat:SetUIScale( 10 )
	bladecat:SetIgnoreZ( false )
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles + Angle( 0, 0, 0 )
	bladecat.CamPos = spos + sang*wOS[ wOS.CurrentCraftTable ].UseLength*0.5
	bladecat.CamAng = cang
	wOS.CraftingCamera[ language.GetPhrase( "wos_option_color" ) ] = { origin = bladecat.CamPos + Vector( -15, -10, 5 ), angles = Vector( 15, -7, -5 ):Angle() + Angle( 0, 45, 0 ) - Angle( 0, 360, 0 )  }
	table.insert( wOS.CraftingButtons, bladecat )
	
	local hiltcat = tduiw.Create()
	hiltcat.SizeX = 10
	hiltcat.SizeY = 5
	hiltcat.ShouldAcceptInputs = true
	hiltcat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Line( 0, 0, 0, -15 + 2*hh )
		pan:Line( 0, -15 + 2*hh, -5, -15 + hh/2 )
		pan:Rect( -5 - ww, -15, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		--pan:Text( "Crystal", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local _jp, _pr, _hov = pan:Button(language.GetPhrase( "wos_option_hilt" ), "wOS.TitleFont", -5 - ww, -15, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_option_hilt" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	hiltcat:SetUIScale( 10 )
	hiltcat:SetIgnoreZ( false )
	local apos, aang = wOS:FindHandPosAng( wOS.CraftingMenu.Saber )	
	hiltcat.CamPos = apos
	hiltcat.CamAng = cang
	wOS.CraftingCamera[ language.GetPhrase( "wos_option_hilt" ) ] = { origin = hiltcat.CamPos + Vector( 0, 0, 30 ), angles = ( Vector( 0, 0, -30 ) ):Angle() + Angle( 0, 0, 90 ) }
	table.insert( wOS.CraftingButtons, hiltcat )
	
	local ignitecat = tduiw.Create()
	ignitecat.SizeX = 15
	ignitecat.SizeY = 5
	ignitecat.ShouldAcceptInputs = true
	ignitecat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Line( 0, 0, 0, 15 - 2*hh )
		pan:Line( 0, 15 - 2*hh, 5, 15 - hh/2 )
		pan:Rect( 5, 15 - hh, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		--pan:Text( "Crystal", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local _jp, _pr, _hov = pan:Button(language.GetPhrase( "wos_info_igniter" ), "wOS.TitleFont", 5, 15 - hh, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_info_igniter" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	ignitecat:SetUIScale( 10 )
	ignitecat:SetIgnoreZ( false )
	ignitecat.CamPos = spos
	ignitecat.CamAng = cang
	wOS.CraftingCamera[ language.GetPhrase( "wos_info_igniter" ) ] = { origin = ignitecat.CamPos + Vector( -5, -5, -2 ), angles = Vector( 5, 5, 2 ):Angle() - Angle( 360, 0, 0 )  }
	table.insert( wOS.CraftingButtons, ignitecat )
	
	local idlecat = tduiw.Create()
	idlecat.SizeX = 15
	idlecat.SizeY = 5
	idlecat.ShouldAcceptInputs = true
	idlecat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Line( 0, 0, 0, 15 - 2*hh )
		pan:Line( 0, 15 - 2*hh, -5, 15 - hh/2 )
		pan:Rect( -5 - ww, 15 - hh, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		--pan:Text( "Crystal", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local _jp, _pr, _hov = pan:Button(language.GetPhrase( "wos_info_humsound" ), "wOS.TitleFont", -5 - ww, 15 - hh, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_info_humsound" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	idlecat:SetUIScale( 10 )
	idlecat:SetIgnoreZ( false )
	idlecat.CamPos = apos - aang*3
	idlecat.CamAng = cang
	wOS.CraftingCamera[ language.GetPhrase( "wos_info_humsound" ) ] = { origin = idlecat.CamPos + Vector( 5, 5, -5 ), angles = Vector( -5, -5, 5 ):Angle() - Angle( 360, 360, 0 )  }
	table.insert( wOS.CraftingButtons, idlecat )
	
	local powercat = tduiw.Create()
	powercat.SizeX = 20
	powercat.SizeY = 5
	powercat.ShouldAcceptInputs = true
	powercat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Line( 0, 0, -5, -5 )
		pan:Line( -5, -5, -15, -5 )
		pan:Rect( -15 - ww, -5 - hh/2, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		--pan:Text( "Crystal", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local _jp, _pr, _hov = pan:Button(language.GetPhrase( "wos_info_swingsound" ), "wOS.TitleFont", -15 - ww, -5 - hh/2, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_info_swingsound" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	powercat:SetUIScale( 10 )
	powercat:SetIgnoreZ( false )
	powercat.CamPos = apos - aang*1.5
	powercat.CamAng = cang
	wOS.CraftingCamera[ language.GetPhrase( "wos_info_swingsound" ) ] = { origin = powercat.CamPos + Vector( 5, 5, 3 ), angles = Vector( -5, -5, -3 ):Angle() - Angle( 0, 360, 0 )  }
	table.insert( wOS.CraftingButtons, powercat )
	
	local bluecat = tduiw.Create()
	bluecat.SizeX = 20
	bluecat.SizeY = 25
	bluecat.ShouldAcceptInputs = true
	bluecat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 35
		pan:Rect( x, -10, ww, hh/8, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( language.GetPhrase( "wos_info_blueprints" ), "wOS.TitleFont", x, -10, ww, hh/8 )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_info_blueprints" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:Rect( x, -6.3, ww, hh/8, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( language.GetPhrase( "wos_info_miscitem" ), "wOS.TitleFont", x, -6.3, ww, hh/8 )
	    if _jp then
			surface.PlaySound( "buttons/button9.wav" )
	       	wOS.CraftingFocus = language.GetPhrase( "wos_info_miscitem" )
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	bluecat:SetUIScale( 20 )
	bluecat.Scaling = 0.05
	bluecat:SetIgnoreZ( false )
	bluecat.CamPos = apos - aang*1.5
	bluecat.CamAng = cang
	wOS.CraftingCamera[ language.GetPhrase( "wos_info_miscitem" ) ] = { origin = centerpoint - Vector( 100, -35, -25 ), angles = Angle( 20.840, 30.501, 0.000 )  }
	wOS.CraftingCamera[ language.GetPhrase( "wos_info_blueprints" ) ] = { origin = centerpoint - Vector( 100, -35, -25 ), angles = Angle( 20.840, 30.501, 0.000 )  }
	table.insert( wOS.CraftingButtons, bluecat )
	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 20
	backbutt.SizeY = 25
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 35
		pan:Rect( x, -10 - hh*(7/8) - 0.5, ww, hh*(7/8), Color( 25, 25, 25, 245 ), color_white )		
		pan:Rect( x, -10 - hh*(7/8) - 0.5, ww, hh*(1/8), Color( 25, 25, 25, 245 ), color_white )
		pan:Text( "Current Stats", "wOS.TitleFont", x + ww*0.05, -10 - hh*(7/8) - 0.5 + hh/16, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		pan:Text( "Proficiency Level: " .. LocalPlayer():GetNW2Int( "wOS.ProficiencyLevel", 0 ), "wOS.TitleFont", x + ww*0.95, -10 - hh*(7/8) - 0.5 + hh/16, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )	
		pan:Text( "Hilt: " .. wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.HILT ], "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		pan:Text( "Crystal: " .. wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.CRYSTAL ], "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Text( "Idle Regulator: " .. wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IDLE ], "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Text( "Crystal Activator: " .. wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IGNITER ], "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 6, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
		pan:Text( "Power Vortex Regulator: " .. wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.VORTEX ], "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 8, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Text( "Blade Length: " .. wOS[ wOS.CurrentCraftTable ].UseLength, "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
		pan:Text( "Blade Width: " .. wOS[ wOS.CurrentCraftTable ].UseWidth, "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Text( "Base Damage: " .. wOS[ wOS.CurrentCraftTable ].SaberDamage, "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 14, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Text( "Base Burn Damage: " .. wOS[ wOS.CurrentCraftTable ].SaberBurnDamage, "wOS.TitleFont", x + 1, -10 - hh*(7/8) - 0.5 + hh/8 + 1.5 + 16, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Rect( x, 1, ww, hh/8, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Fabricate", "wOS.TitleFont", x, 1, ww, hh/8 )
	    if _jp then
			surface.PlaySound( "buttons/button24.wav" )
			wOS:CleanCraftingMenus()
			net.Start( "wOS.Crafting.UpdateItems" )
				net.WriteTable( wOS.EquippedItems )
				net.WriteTable( wOS.SecEquippedItems )
				net.WriteTable( wOS.SaberMiscSlots )
			net.SendToServer()
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 20 )
	backbutt.Scaling = 0.05
	backbutt.CamPos = apos - aang*1.5
	backbutt.CamAng = cang
	
	table.insert( wOS.CraftingButtons, backbutt )			
	
end

wOS.CraftMenuLibrary[ language.GetPhrase( "wos_option_color" ) ] = function()
	local spos, sang = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	
	local sorted_list = {}
	sorted_list[1] = wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.CRYSTAL ]
	if sorted_list[1] != "Standard" then
		sorted_list[2] = "Standard"
	end
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.CRYSTAL ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	local bladecat = tduiw.Create()
	bladecat.SizeX = 10
	bladecat.SizeY = 2.5
	bladecat.ShouldAcceptInputs = true
	bladecat.ScrollMin = 1
	bladecat.ScrollMax = 3
	bladecat.SortedList = table.Copy( sorted_list )
	bladecat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local offset = 2
		local bw, bh = ww, hh*0.5
		
		if #pan.SortedList > 3  then
			pan:Mat( upButton, ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMin > 1 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, ww*0.48 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh )
			pan:Rect( ww*0.48 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh, Color( 0, 0, 0, 0 ), color_white )					
		end
		
		
		for i = pan.ScrollMin, pan.ScrollMax do
			local data = wOS.SortedItemList[ WOSTYPE.CRYSTAL ][ pan.SortedList[ i ] ]
			if not data then continue end
			pan:Rect( ww*0.5, offset, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data.Name, "wOS.CraftDescriptions", ww*0.5 + bw*0.01, offset + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( data.Description, "wOS.CraftMinors", ww*0.5 + bw*0.01, offset + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if data.BurnOnUse then
				pan:Text( "BURNED ON USE", "wOS.CraftMinors", ww*0.5 + bw*0.98, offset + bh*0.05, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )			
			end
			if wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.CRYSTAL ] == data.Name then
				pan:Rect( ww*0.5, offset, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )				
			else
				local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", ww*0.5, offset, bw, bh )
				if _jp then
					surface.PlaySound( "buttons/button9.wav" )
					wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.CRYSTAL ] = data.Name
					net.Start( "wOS.Crafting.PreviewChange" )
						net.WriteBool( wOS.UsingDualLightsaber )
						net.WriteTable( wOS[ wOS.CurrentInventoryTable ] )
					net.SendToServer()
				end
			end
			offset = offset + bh + 0.25
		end
		if #pan.SortedList > 3  then
			offset = offset - 0.25
			pan:Mat( downButton, ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end
		end
	end
	bladecat:SetUIScale( 100 )
	bladecat.Scaling = 0.01
	bladecat.CamPos = spos + sang*wOS[ wOS.CurrentCraftTable ].UseLength*0.5
	bladecat.CamAng = sang:Angle() + Angle( 0, 90, 0 )
	
	table.insert( wOS.CraftingButtons, bladecat )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Rect( -2*ww, 4, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", -2*ww, 4, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.01	
	backbutt.CamPos = spos + sang*wOS[ wOS.CurrentCraftTable ].UseLength*0.5
	backbutt.CamAng = sang:Angle() + Angle( 0, 90, 0 )
	
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

wOS.CraftMenuLibrary[ language.GetPhrase( "wos_option_hilt" ) ] = function()
	local spos, sang = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	local apos, aang = wOS:FindHandPosAng( wOS.CraftingMenu.Saber )	
	
	local sorted_list = {}
	sorted_list[1] = wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.HILT ]
	if sorted_list[1] != "Standard" then
		sorted_list[2] = "Standard"
	end
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.HILT ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	if wOS[ wOS.CurrentCraftTable ].UseHilt:find( "maul_saber_staff" ) then
		aang = aang*-1
	end
	
	local bladecat = tduiw.Create()
	bladecat.SizeX = 10
	bladecat.SizeY = 2.5
	bladecat.ShouldAcceptInputs = true
	bladecat.ScrollMin = 1
	bladecat.ScrollMax = 3
	bladecat.SortedList = table.Copy( sorted_list )
	bladecat.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local offset = -2.3
		local bw, bh = ww, hh*0.5
		
		if #pan.SortedList > 3  then
			pan:Mat( upButton, ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMin > 1 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, ww*0.48 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh )
			pan:Rect( ww*0.48 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh, Color( 0, 0, 0, 0 ), color_white )					
		end
		
		
		for i = pan.ScrollMin, pan.ScrollMax do
			local data = wOS.SortedItemList[ WOSTYPE.HILT ][ pan.SortedList[ i ] ]
			if not data then continue end
			pan:Rect( ww*0.5, offset, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data.Name, "wOS.CraftDescriptions", ww*0.5 + bw*0.01, offset + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( data.Description, "wOS.CraftMinors", ww*0.5 + bw*0.01, offset + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if data.BurnOnUse then
				pan:Text( "BURNED ON USE", "wOS.CraftMinors", ww*0.5 + bw*0.98, offset + bh*0.05, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )			
			end
			if wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.HILT ] == data.Name then
				pan:Rect( ww*0.5, offset, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )				
			else
				local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", ww*0.5, offset, bw, bh )
				if _jp then
					surface.PlaySound( "buttons/button9.wav" )
					wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.HILT ] = data.Name
					net.Start( "wOS.Crafting.PreviewChange" )
						net.WriteBool( wOS.UsingDualLightsaber )
						net.WriteTable( wOS[ wOS.CurrentInventoryTable ] )
					net.SendToServer()
				end
			end
			offset = offset + bh + 0.25
		end
		if #pan.SortedList > 3  then
			offset = offset - 0.25
			pan:Mat( downButton, ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", ww*0.48 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end
		end
	end
	bladecat:SetUIScale( 100 )
	bladecat.Scaling = 0.01
	bladecat.CamPos = apos + Vector( 0, 0, 8 )
	bladecat.CamAng = aang:Angle() + Angle( 94, -5, 0 )
	
	table.insert( wOS.CraftingButtons, bladecat )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Rect( -9 - ww/2, 4, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", -9 - ww/2, 4, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.01	
	backbutt.CamPos = apos + Vector( 0, 0, 8 )
	backbutt.CamAng = aang:Angle() + Angle( 94, -5, 0 )
	
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

wOS.CraftMenuLibrary[ language.GetPhrase( "wos_info_igniter" ) ] = function()
	local spos, sang = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	local apos, aang = wOS:FindHandPosAng( wOS.CraftingMenu.Saber )	
	
	local sorted_list = {}
	sorted_list[1] = wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IGNITER ]
	if sorted_list[1] != "Standard" then
		sorted_list[2] = "Standard"
	end
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.IGNITER ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	local bladecat2 = tduiw.Create()
	bladecat2.SizeX = 10
	bladecat2.SizeY = 2.5
	bladecat2.ShouldAcceptInputs = true
	bladecat2.ScrollMin = 1
	bladecat2.ScrollMax = 3
	bladecat2.SortedList = table.Copy( sorted_list )
	bladecat2.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = -2
		local offset = 3.5
		local bw, bh = ww, hh*0.5
		if #pan.SortedList > 3 then
			pan:Mat( upButton, x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMin > 1 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, x*1.1 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh )
			pan:Rect( x*1.1 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh, Color( 0, 0, 0, 0 ), color_white )					
		end
		
		
		for i = pan.ScrollMin, pan.ScrollMax do
			local data = wOS.SortedItemList[ WOSTYPE.IGNITER ][ pan.SortedList[ i ] ]
			if not data then continue end
			pan:Rect( x, offset, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data.Name, "wOS.CraftDescriptions", x + bw*0.01, offset + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( data.Description, "wOS.CraftMinors", x + bw*0.01, offset + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if data.BurnOnUse then
				pan:Text( "BURNED ON USE", "wOS.CraftMinors", x + bw*0.98, offset + bh*0.05, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )			
			end
			if wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IGNITER ] == data.Name then
				pan:Rect( x, offset, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )				
			else
				local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x, offset, bw, bh )
				if _jp then
					surface.PlaySound( "buttons/button9.wav" )
					wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IGNITER ] = data.Name
					net.Start( "wOS.Crafting.PreviewChange" )
						net.WriteBool( wOS.UsingDualLightsaber )
						net.WriteTable( wOS[ wOS.CurrentInventoryTable ] )
					net.SendToServer()
				end
			end
			offset = offset + bh + 0.25
		end
		if #pan.SortedList > 3  then
			offset = offset - 0.25
			pan:Mat( downButton, x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end
		end
	end
	bladecat2:SetUIScale( 100 )
	bladecat2.Scaling = 0.004
	bladecat2.CamPos = spos
	bladecat2.CamAng = sang:Angle() + Angle( 0, 90, 0 )
	
	table.insert( wOS.CraftingButtons, bladecat2 )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Rect( -11 - ww/2, 3, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", -11 - ww/2, 3, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.005	
	backbutt.CamPos = spos
	backbutt.CamAng = sang:Angle() + Angle( 0, 90, 0 )
	
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

wOS.CraftMenuLibrary[ language.GetPhrase( "wos_info_humsound" ) ] = function()
	local spos, sang = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	local apos, aang = wOS:FindHandPosAng( wOS.CraftingMenu.Saber )	
	
	local sorted_list = {}
	sorted_list[1] = wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IDLE ]
	if sorted_list[1] != "Standard" then
		sorted_list[2] = "Standard"
	end
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.IDLE ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	local bladecat2 = tduiw.Create()
	bladecat2.SizeX = 10
	bladecat2.SizeY = 2.5
	bladecat2.ShouldAcceptInputs = true
	bladecat2.ScrollMin = 1
	bladecat2.ScrollMax = 3
	bladecat2.SortedList = table.Copy( sorted_list )
	bladecat2.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = -2
		local offset = 3.5
		local bw, bh = ww, hh*0.5
		if #pan.SortedList > 3 then
			pan:Mat( upButton, x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMin > 1 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, x*1.1 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh )
			pan:Rect( x*1.1 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh, Color( 0, 0, 0, 0 ), color_white )					
		end
		
		
		for i = pan.ScrollMin, pan.ScrollMax do
			local data = wOS.SortedItemList[ WOSTYPE.IDLE ][ pan.SortedList[ i ] ]
			if not data then continue end
			pan:Rect( x, offset, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data.Name, "wOS.CraftDescriptions", x + bw*0.01, offset + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( data.Description, "wOS.CraftMinors", x + bw*0.01, offset + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if data.BurnOnUse then
				pan:Text( "BURNED ON USE", "wOS.CraftMinors", x + bw*0.98, offset + bh*0.05, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )			
			end
			if wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IDLE ] == data.Name then
				pan:Rect( x, offset, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )				
			else
				local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x, offset, bw, bh )
				if _jp then
					surface.PlaySound( "buttons/button9.wav" )
					wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.IDLE ] = data.Name
					net.Start( "wOS.Crafting.PreviewChange" )
						net.WriteBool( wOS.UsingDualLightsaber )
						net.WriteTable( wOS[ wOS.CurrentInventoryTable ] )
					net.SendToServer()
				end
			end
			offset = offset + bh + 0.25
		end
		if #pan.SortedList > 3  then
			offset = offset - 0.25
			pan:Mat( downButton, x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x*1.1 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end
		end
	end
	bladecat2:SetUIScale( 100 )
	bladecat2.Scaling = 0.004
	bladecat2.CamPos = apos - aang*3
	bladecat2.CamAng = sang:Angle() + Angle( 0, -90, 0 )
	
	table.insert( wOS.CraftingButtons, bladecat2 )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Rect( -11 - ww/2, 3, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", -11 - ww/2, 3, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.005	
	backbutt.CamPos = apos - aang*3
	backbutt.CamAng = sang:Angle() + Angle( 0, -90, 0 )
	
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

wOS.CraftMenuLibrary[ language.GetPhrase( "wos_info_swingsound" ) ] = function()
	local spos, sang = wOS:FindBladePosAng( nil, false, wOS.CraftingMenu.Saber )
	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	local apos, aang = wOS:FindHandPosAng( wOS.CraftingMenu.Saber )	
	
	local sorted_list = {}
	sorted_list[1] = wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.VORTEX ]
	if sorted_list[1] != "Standard" then
		sorted_list[2] = "Standard"
	end
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.VORTEX ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	local bladecat2 = tduiw.Create()
	bladecat2.SizeX = 10
	bladecat2.SizeY = 2.5
	bladecat2.ShouldAcceptInputs = true
	bladecat2.ScrollMin = 1
	bladecat2.ScrollMax = 3
	bladecat2.SortedList = table.Copy( sorted_list )
	bladecat2.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 0
		local offset = -11
		local bw, bh = ww, hh*0.5
		if #pan.SortedList > 3 then
			pan:Mat( upButton, x - 0.5 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x - 0.5 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMin > 1 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, x - 0.5 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh )
			pan:Rect( x - 0.5 - hh/2, offset + bh/2 + bh/6, hh/2, 2*bh, Color( 0, 0, 0, 0 ), color_white )					
		end
		
		
		for i = pan.ScrollMin, pan.ScrollMax do
			local data = wOS.SortedItemList[ WOSTYPE.VORTEX ][ pan.SortedList[ i ] ]
			if not data then continue end
			pan:Rect( x, offset, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data.Name, "wOS.CraftDescriptions", x + bw*0.01, offset + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( data.Description, "wOS.CraftMinors", x + bw*0.01, offset + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if data.BurnOnUse then
				pan:Text( "BURNED ON USE", "wOS.CraftMinors", x + bw*0.98, offset + bh*0.05, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )			
			end
			if wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.VORTEX ] == data.Name then
				pan:Rect( x, offset, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )				
			else
				local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x, offset, bw, bh )
				if _jp then
					surface.PlaySound( "buttons/button9.wav" )
					wOS[ wOS.CurrentInventoryTable ][ WOSTYPE.VORTEX ] = data.Name
					net.Start( "wOS.Crafting.PreviewChange" )
						net.WriteBool( wOS.UsingDualLightsaber )
						net.WriteTable( wOS[ wOS.CurrentInventoryTable ] )
					net.SendToServer()
				end
			end
			offset = offset + bh + 0.25
		end
		if #pan.SortedList > 3  then
			offset = offset - 0.25
			pan:Mat( downButton, x - 0.5 - hh/2, offset - bh/2, hh/2, hh/2 )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x - 0.5 - hh/2, offset - bh/2, hh/2, hh/2 )
			if _jp then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end
		end
	end
	bladecat2:SetUIScale( 100 )
	bladecat2.Scaling = 0.003
	bladecat2.CamPos = apos - aang*3
	bladecat2.CamAng = sang:Angle() + Angle( 0, -90, 0 )
	
	table.insert( wOS.CraftingButtons, bladecat2 )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		pan:Rect( -5 - ww/2, 3, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", -5 - ww/2, 3, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.005	
	backbutt.CamPos = apos - aang*3
	backbutt.CamAng = sang:Angle() + Angle( 0, -90, 0 )
	
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

local blueprint_selected = false

wOS.CraftMenuLibrary[ language.GetPhrase( "wos_info_blueprints" ) ] = function()

	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	
	blueprint_selected = false
	
	local sorted_list = {}
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.BLUEPRINT ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	if IsValid( wOS.blueprint_item ) then wOS.blueprint_item:Remove() end
	wOS.blueprint_floor = ClientsideModel( "models/gangwars/crafting/blup.mdl", RENDERGROUP_BOTH )
	wOS.blueprint_floor:SetPos( cpos + Vector( 40, 30, -30 ) )
	
	wOS.blueprint_item = ClientsideModel( "models/heat/heat.mdl", RENDERGROUP_BOTH )
	wOS.blueprint_item:SetPos( wOS.blueprint_floor:GetPos() + Vector( 0, 0, 10 ) )
	wOS.blueprint_item:SetMaterial( "models/wireframe" )
	wOS.blueprint_item.Think = function( model )
		local ang = model:GetAngles()
		ang:RotateAroundAxis( ang:Up(), 0.1 )
		model:SetAngles( ang )
	end
	
	local selected = false
	
	local infobutt = tduiw.Create()
	infobutt.SizeX = 18
	infobutt.SizeY = 20
	infobutt.ShouldAcceptInputs = true
	infobutt.Renders = function( pan )
		if not blueprint_selected then return end
		local ww, hh = pan.SizeX, pan.SizeY
		local offset = -13
		local offsety = hh*0.035
		local bw, bh = ww*1.3, hh
		local x = 0
		pan:Rect( offset - ww/2, 0, ww, hh*0.84, Color( 25, 25, 25, 245 ), color_white )
		
		pan:Text( "Requirements", "wOS.CraftTitles", offset, offsety - hh*0.01, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
		pan:Line( offset - ww/2, offsety + hh*0.07, offset + ww/2, offsety + hh*0.07 )
		offsety = offsety + hh*0.08
		for material, amount in pairs( blueprint_selected.Ingredients ) do
			pan:Text( material .. ": " .. amount, "wOS.CraftTitles", offset - ww*0.48, offsety, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
			offsety = offsety + hh*0.08			
		end
		if blueprint_selected.Result then
			pan:Text( "Result: " .. blueprint_selected.Result, "wOS.CraftTitles", offset - ww*0.48, hh*0.76, Color( 0, 128, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
			
		pan:Rect( offset - ww/2, hh*0.85, ww, hh*0.15, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Craft Blueprint", "wOS.CraftTitles", offset - ww/2, hh*0.85, ww, hh*0.15 )
	    if _jp then
			net.Start( "wOS.Crafting.CraftBlueprint" )
				net.WriteString( blueprint_selected.Name )
			net.SendToServer()
	    end	
		pan:BlockUseBind()
		
	end
	infobutt:SetUIScale( 100 )
	infobutt.Scaling = 0.01	
	infobutt.CamPos = cpos + Vector( 50, -10, 0 )
	infobutt.CamAng = cang
	table.insert( wOS.CraftingButtons, infobutt )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ScrollMin = 1
	backbutt.ScrollMax = 6
	backbutt.SortedList = table.Copy( sorted_list )
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local offset = -11
		local offsety = 0
		local bw, bh = ww*1.3, hh
		local x = offset - bw/2		
		if #pan.SortedList > 6 then
			pan:Mat( upButton, offset + bw*0.7, 3, bh, bh )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", offset + bw*0.7, 3, bh, bh )
			if _jp then
				if pan.ScrollMin > 6 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, offset + bw*0.7, 3 + bh*1.2, bh, 2*bh )
			pan:Rect( offset + bw*0.7, 3 + bh*1.2, bh, 2*bh, Color( 0, 0, 0, 0 ), color_white )		

			pan:Mat( downButton, offset + bw*0.7, 3 + bh*1.4 + 2*bh, bh, bh )
			local _jp2, _pr2, _hov2 = pan:Button("", "wOS.CraftDescriptions", offset + bw*0.7, 3 + bh*1.4 + 2*bh, bh, bh )
			if _jp2 then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end			
		end

		for i = pan.ScrollMin, pan.ScrollMax do
			local data = wOS.SortedItemList[ WOSTYPE.BLUEPRINT ][ pan.SortedList[ i ] ]
			if not data then continue end
			pan:Rect( x, offsety, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data.Name, "wOS.CraftDescriptions", x + bw*0.01, offsety + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( data.Description, "wOS.CraftMinors", x + bw*0.01, offsety + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if data.BurnOnUse then
				pan:Text( "BURNED ON USE", "wOS.CraftMinors", x + bw*0.98, offsety + bh*0.05, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )			
			end
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x, offsety, bw, bh )
			if _jp then
				surface.PlaySound( "buttons/button9.wav" )
				blueprint_selected = wOS.SortedItemList[ WOSTYPE.BLUEPRINT ][ pan.SortedList[ i ] ]
				local item = blueprint_selected.Result
				if item then
					item = wOS.ItemList[ item ]
					if item then
						if item.Model then
							wOS.blueprint_item:SetModel( item.Model )
						end
					end
				end
			end
			offsety = offsety + bh + 0.25
		end
		
		pan:Rect( offset - ww/2, 15, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", offset - ww/2, 15, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
			wOS.blueprint_floor:Remove()
			wOS.blueprint_item:Remove()
			wOS.blueprint_floor = nil
			wOS.blueprint_item = nil
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.01	
	backbutt.CamPos = cpos + Vector( 20, 20, 0 )
	backbutt.CamAng = cang
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

local slot_selected = false
local DefaultEmpty = {
	Name = "Empty",
	Description = "",
}
wOS.CraftMenuLibrary[ language.GetPhrase( "wos_info_miscitem" ) ] = function()

	local cpos = wOS.CraftingCamera[ wOS.CraftingFocus ].origin
	local cang = wOS.CraftingCamera[ wOS.CraftingFocus ].angles
	
	slot_selected = false
	local sorted_list = {}
	sorted_list[1] = "Empty"
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.MISC1 ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	for name, data in pairs( wOS.SortedItemList[ WOSTYPE.MISC2 ] ) do
		if table.HasValue( wOS.SaberInventory, name ) then
			if !table.HasValue( sorted_list, name ) then
				sorted_list[ #sorted_list + 1 ] = name
			end
		end
	end
	
	wOS.blueprint_item = ClientsideModel( "models/heat/heat.mdl", RENDERGROUP_BOTH )
	wOS.blueprint_item:SetPos( cpos + Vector( 40, 25, -20 ) )
	wOS.blueprint_item.Think = function( model )
		local ang = model:GetAngles()
		ang:RotateAroundAxis( ang:Up(), 0.1 )
		model:SetAngles( ang )
	end
	
	local selected = false
	
	local infobutt = tduiw.Create()
	infobutt.SizeX = 8
	infobutt.SizeY = 2
	infobutt.ScrollMin = 1
	infobutt.ScrollMax = 6
	infobutt.SortedList = table.Copy( sorted_list )
	infobutt.ShouldAcceptInputs = true
	infobutt.Renders = function( pan )
		if not slot_selected then return end
		local ww, hh = pan.SizeX, pan.SizeY
		local offset = -11
		local offsety = 0
		local bw, bh = ww*1.3, hh
		local x = offset - bw/2		
		if #pan.SortedList > 6 then
			pan:Mat( upButton, offset + bw*0.7, 3, bh, bh )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", offset + bw*0.7, 3, bh, bh )
			if _jp then
				if pan.ScrollMin > 6 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, offset + bw*0.7, 3 + bh*1.2, bh, 2*bh )
			pan:Rect( offset + bw*0.7, 3 + bh*1.2, bh, 2*bh, Color( 0, 0, 0, 0 ), color_white )		

			pan:Mat( downButton, offset + bw*0.7, 3 + bh*1.4 + 2*bh, bh, bh )
			local _jp2, _pr2, _hov2 = pan:Button("", "wOS.CraftDescriptions", offset + bw*0.7, 3 + bh*1.4 + 2*bh, bh, bh )
			if _jp2 then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end			
		end

		for i = pan.ScrollMin, pan.ScrollMax do
			local name = pan.SortedList[ i ]
			if not name then continue end
			local item = wOS.ItemList[ name ]
			if not item then item = DefaultEmpty end
			pan:Rect( x, offsety, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( name, "wOS.CraftDescriptions", x + bw*0.01, offsety + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan:Text( item.Description, "wOS.CraftMinors", x + bw*0.01, offsety + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if table.KeyFromValue( wOS.SaberMiscSlots, name ) != slot_selected and table.HasValue( wOS.SaberMiscSlots, name ) then
				pan:Rect( x, offsety, bw, bh, Color( 0, 0, 0, 0 ), Color( 255, 0, 0 ) )	
			else
				if wOS.SaberMiscSlots[ slot_selected ] == name then
					pan:Rect( x, offsety, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )	
				else
					local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x, offsety, bw, bh )
					if _jp then
						surface.PlaySound( "buttons/button9.wav" )
						if name == "Empty" then wOS.SaberMiscSlots[ slot_selected ] = nil return end
						wOS.SaberMiscSlots[ slot_selected ] = name
						if item.Model then
							wOS.blueprint_item:SetModel( item.Model )
						end
					end
				end
			end
			offsety = offsety + bh + 0.25
		end
		
		pan:BlockUseBind()
	end
	infobutt:SetUIScale( 100 )
	infobutt.Scaling = 0.01	
	infobutt.CamPos = cpos + Vector( 40, -10, 0 )
	infobutt.CamAng = cang
	table.insert( wOS.CraftingButtons, infobutt )

	local slots = math.floor( LocalPlayer():GetNW2Int( "wOS.ProficiencyLevel", 0 )/wOS.LevelPerSlot )
	local slotlist = {}
	for i=1, slots do
		slotlist[ i ] = "Slot " .. i
	end
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 8
	backbutt.SizeY = 2
	backbutt.ScrollMin = 1
	backbutt.ScrollMax = 6
	backbutt.SortedList = table.Copy( slotlist )
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local offset = -11
		local offsety = 0
		local bw, bh = ww*1.3, hh
		local x = offset - bw/2		
		if #pan.SortedList > 6 then
			pan:Mat( upButton, offset + bw*0.7, 3, bh, bh )
			local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", offset + bw*0.7, 3, bh, bh )
			if _jp then
				if pan.ScrollMin > 6 then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin - 1
					pan.ScrollMax = pan.ScrollMax - 1
				end
			end
				
			pan:Mat( bufferBar, offset + bw*0.7, 3 + bh*1.2, bh, 2*bh )
			pan:Rect( offset + bw*0.7, 3 + bh*1.2, bh, 2*bh, Color( 0, 0, 0, 0 ), color_white )		

			pan:Mat( downButton, offset + bw*0.7, 3 + bh*1.4 + 2*bh, bh, bh )
			local _jp2, _pr2, _hov2 = pan:Button("", "wOS.CraftDescriptions", offset + bw*0.7, 3 + bh*1.4 + 2*bh, bh, bh )
			if _jp2 then
				if pan.ScrollMax < #pan.SortedList then
					surface.PlaySound( "buttons/lightswitch2.wav" )
					pan.ScrollMin = pan.ScrollMin + 1
					pan.ScrollMax = pan.ScrollMax + 1
				end
			end			
		end

		for i = pan.ScrollMin, pan.ScrollMax do
			local data = pan.SortedList[ i ]
			if not data then continue end
			pan:Rect( x, offsety, bw, bh, Color( 25, 25, 25, 245 ), color_white )
			local col = color_white
			pan:Text( data, "wOS.CraftDescriptions", x + bw*0.01, offsety + bh*0.05, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if wOS.SaberMiscSlots[ i ] then
				pan:Text( wOS.SaberMiscSlots[ i ], "wOS.CraftMinors", x + bw*0.01, offsety + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else
				pan:Text( "Empty", "wOS.CraftMinors", x + bw*0.01, offsety + bh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			if slot_selected == i then
				pan:Rect( x, offsety, bw, bh, Color( 0, 0, 0, 0 ), Color( 0, 128, 255 ) )	
			else
				local _jp, _pr, _hov = pan:Button("", "wOS.CraftDescriptions", x, offsety, bw, bh )
				if _jp then
					surface.PlaySound( "buttons/button9.wav" )
					slot_selected = i
					local item = wOS.SaberMiscSlots[i]
					if item then
						item = wOS.ItemList[ item ]
						if item then
							if item.Model then
								wOS.blueprint_item:SetModel( item.Model )
							end
						end
					end
				end
			end
			offsety = offsety + bh + 0.25
		end
		
		pan:Rect( offset - ww/2, 15, ww, hh, Color( 25, 25, 25, 245 ), color_unselected )
		local _jp, _pr, _hov = pan:Button( "Back", "wOS.CraftTitles", offset - ww/2, 15, ww, hh )
	    if _jp then
			surface.PlaySound( "buttons/combine_button2.wav" )
			wOS.blueprint_item:Remove()
			wOS.blueprint_item = nil
	       	wOS.CraftingFocus = "Overview"
			wOS:RebuildCraftingMenus() 
	    end	
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 100 )
	backbutt.Scaling = 0.01	
	backbutt.CamPos = cpos + Vector( 20, 20, 0 )
	backbutt.CamAng = cang
	table.insert( wOS.CraftingButtons, backbutt )		
	
end

hook.Add( "Think", "wOS.Crafting.HUDTraces", function()
	--Code taken from Toxsin X. Nice to have this handy again!
	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) )
	local item = tr.Entity
	if !IsValid( item ) then lookingat = nil return end
	if item:GetClass() != "wos_item_base" and !item:IsPlayer() then lookingat = nil return end
	local dist = item:GetPos():Distance( LocalPlayer():GetPos() )
	if item:GetClass() == "wos_item_base" then
		if dist < 150 then
			if !lookingat or lookingat.Item:IsPlayer() then
				lookingat = tduiw.Create()
				lookingat.SizeX = 16
				lookingat.SizeY = 2
				lookingat.ShouldAcceptInputs = true
				lookingat.Renders = function( pan )
					if not IsValid( pan.Item ) then pan = nil return end
					local ww, hh = pan.SizeX, pan.SizeY
					pan:Line( 0, 0, 1, -2.5 )
					pan:Line( 1, -2.5, 3, -5 + hh/2 )			
					pan:Rect( 3, -5, ww, hh, Color( 25, 25, 25, 245 ), color_white )
					local typ = pan.Item:GetItemType()
					if ItemTable[ typ ] then
						local b = hh*2	
						pan:Mat( ItemTable[ typ ], 3 + ww/2 - b/2, -5 - b*0.9, b, b ) 
					end
					local title_text = pan.Item:GetItemName()
					if typ == WOSTYPE.RAWMATERIAL then
						local amt = pan.Item:GetAmount()
						if amt > 1 then
							title_text = title_text .. " ( x" .. amt .. " )"
						end
					end
					pan:Text( title_text, "wOS.ItemTitles", 3 + ww*0.01, -5 + hh*0.2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
					pan:Text( pan.Item:GetItemDescription(), "wOS.ItemDescriptions", 3 + ww*0.01, -5 + hh*0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )				
				end
				lookingat:SetUIScale( 200 )	
			end
			lookingat.Scaling = math.max( dist / 5000, 0.015 )
			lookingat.CamPos = item:GetPos()
			lookingat.CamAng = LocalPlayer():GetAimVector():Angle()
			lookingat.Item = item
		else
			lookingat = nil 
		end
	elseif item:IsPlayer() and wOS.MountLevelToPlayer then
		if dist < 175 then
			if !lookingat then
				lookingat = tduiw.Create()
				lookingat.SizeX = 4
				lookingat.SizeY = 1
				lookingat.ShouldAcceptInputs = true
				lookingat.Renders = function( pan )
					if not IsValid( pan.Item ) then pan = nil return end
					local ww, hh = pan.SizeX, pan.SizeY
					pan:Text( "Combat Level: " .. pan.Item:GetSkillLevel(), "wOS.ItemTitles", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )			
				end
				lookingat:SetUIScale( 200 )	
			end
			lookingat.Scaling = math.max( dist / 2500, 0.03 )
			lookingat.CamPos = item:EyePos() + Vector( 0, 0, 14 )
			lookingat.CamAng = LocalPlayer():GetAimVector():Angle()
			lookingat.Item = item
		else
			lookingat = nil 
		end		
	end
end )

hook.Add( "PreDrawHalos", "wOS.Crafting.ItemClose", function()
	if not lookingat then return end
	local item = lookingat.Item
	if not IsValid( item ) then return end
	if item:IsPlayer() then return end
	halo.Add( { item }, Color( 255, 255, 255, 255 ), 1, 1, 6, true, false )	
end )