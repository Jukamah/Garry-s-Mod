
--[[-------------------------------------------------------------------
	Advanced Lightsaber Combat Base:
		An intuitively designed lightsaber combat base.
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

include( "shared.lua" )

if ( SERVER ) then return end

killicon.Add( "weapon_lightsaber_wos", "lightsaber/lightsaber_killicon", color_white )

local WepSelectIcon = Material( "lightsaber/selection.png" )
local Size = 96

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	surface.SetDrawColor( 255, 255, 255, a )
	surface.SetMaterial( WepSelectIcon )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	surface.DrawTexturedRect( x + ( ( w - Size ) / 2 ), y + ( ( h - Size ) / 2.5 ), Size, Size )

	render.PopFilterMag()
	render.PopFilterMin()
end

function SWEP:DrawWorldModel()
	self:DrawWorldModelTranslucent()
end

function SWEP:DrawWorldModelTranslucent()
	self.WorldModel = self:GetWorldModel()
	self:SetModel( self:GetWorldModel() )

	if ( !IsValid( self:GetOwner() ) or halo.RenderedEntity() == self ) then return end
	
	if self.Owner:GetNW2Float( "CloakTime", 0 ) >= CurTime() then 
		local vel = self.Owner:GetVelocity():Length()
		if vel < 130 then return end
		self:SetMaterial("models/shadertest/shader3")
		self:DrawModel()
		return
	else
		self:SetMaterial( "" )
		self:DrawModel()
	end
	
	if self.NoBlade then return end
	
	local clr = self:GetCrystalColor()
	clr = Color( clr.x, clr.y, clr.z )

	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0
	for id, t in pairs( self:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && self:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( bladeNum )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2, false, blades, self.CustomSettings )
			bladesFound = true
		end

		if ( quillonNum && self:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( quillonNum, true )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2, true, blades, self.CustomSettings )
		end

	end

	if ( !bladesFound ) then
		local pos, dir = self:GetSaberPosAng()
		rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2, nil, nil, self.CustomSettings )
	end
end

-- --------------------------------------------------------- 3rd Person Camera --------------------------------------------------------- --

local isCalcViewFuckedUp2 = false

-- --------------------------------------------------------- HUD --------------------------------------------------------- --

surface.CreateFont( "SelectedForceType", {
	font	= "Roboto Cn",
	size	= ScreenScale( 16 ),
	weight	= 600
} )

surface.CreateFont( "SelectedForceHUD", {
	font	= "Roboto Cn",
	size	= ScreenScale( 6 )
} )

local ForceSelectEnabled = false
local rb655_lightsaber_hud_blur = CreateClientConVar( "rb655_lightsaber_hud_blur", "0" )

local grad = Material( "gui/gradient_up" )
local matBlurScreen = Material( "pp/blurscreen" )
matBlurScreen:SetFloat( "$blur", 3 )
matBlurScreen:Recompute()
local function DrawHUDBox( x, y, w, h, b )

	x = math.floor( x )
	y = math.floor( y )
	w = math.floor( w )
	h = math.floor( h )

	surface.SetMaterial( matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )

	if ( rb655_lightsaber_hud_blur:GetBool() ) then
		render.SetScissorRect( x, y, w + x, h + y, true )
			for i = 0.33, 1, 0.33 do
				matBlurScreen:SetFloat( "$blur", 5 * i )
				matBlurScreen:Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			end
		render.SetScissorRect( 0, 0, 0, 0, false )
	else
		draw.NoTexture()
		surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
		surface.DrawTexturedRect( x, y, w, h )
	end

	surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
	surface.DrawRect( x, y, w, h )

	if ( b ) then
		surface.SetMaterial( grad )
		surface.SetDrawColor( Color( 0, 128, 255, 4 ) )
		surface.DrawTexturedRect( x, y, w, h )
	end

end

local isCalcViewFuckedUp = true
function SWEP:ViewModelDrawn()
	isCalcViewFuckedUp = true -- Clever girl!
end

function SWEP:DrawHUDTargetSelection()
	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ( !selectedForcePower ) then return end

	local isTarget = selectedForcePower.target
	local dist = selectedForcePower.distance
	if ( isTarget ) then
		for id, ent in pairs( self:SelectTargets( isTarget, dist ) ) do
			if ( !IsValid( ent ) ) then continue end
			local maxs = ent:OBBMaxs()
			local p = ent:GetPos()
			p.z = p.z + maxs.z

			local pos = p:ToScreen()
			local x, y = pos.x, pos.y
			local size = 16

			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
			surface.DrawPoly( {
				{ x = x - size, y = y - size },
				{ x = x + size, y = y - size },
				{ x = x, y = y }
			} )
		end
	end
end

local ForceBar = 100
local StaminaBar = 100
local DevBar = 0
function SWEP:DrawHUD()
	if ( !IsValid( self.Owner ) or self.Owner:GetViewEntity() != self.Owner or self.Owner:InVehicle() ) then return end

	-----------------------------------

	local icon = 52
	local gap = 5

	local bar = 4
	local bar2 = 16

	if ( self.ForceSelectEnabled ) then
		icon = 128
		bar = 8
		bar2 = 24
	end

	local ForcePowers = self:GetActiveForcePowers()

	if ( #ForcePowers < 1 ) then self:DrawHUDTargetSelection() return end

	----------------------------------- Force Bar -----------------------------------

	ForceBar = math.min( 100, Lerp( 0.1, ForceBar, math.floor( self:GetForce() ) ) )
	DevBar = math.min( 100, Lerp( 0.1, DevBar, math.floor( self:GetDevEnergy() ) ) )

	local w = #ForcePowers * icon + ( #ForcePowers - 1 ) * gap
	if wOS.ForceSelectMenu then
		w = 9* icon + 8 * gap
	end
	local h = bar2
	local x = math.floor( ScrW() / 2 - w / 2 )
	local y = ScrH() - gap - bar2

	DrawHUDBox( x, y, w, h )

	local barW = math.ceil( w * ( ForceBar / 100 ) )
	if ( self:GetForce() <= 1 && barW <= 1 ) then barW = 0 end
	draw.RoundedBox( 0, x, y, barW, h, Color( 0, 128, 255, 255 ) )
	
	local barW2 = math.ceil( w * ( DevBar / 100 ) )
	if ( self:GetDevEnergy() <= 1 && barW2 <= 1 ) then barW2 = 0 end
	draw.RoundedBox( 0, x, y, barW2, h, Color( 225, 0, 225, 125 ) )

	draw.SimpleText( math.floor( self:GetForce() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	if wOS.EnableStamina then
		------------------------------------- STAMINA BAR --------------------------------
		local stam = self:GetStamina()
		StaminaBar = (StaminaBar == stam and stam) or Lerp(0.1, StaminaBar, stam )
		x = math.floor( ScrW()/2 - w / 2 )
		y = ScrH() - gap - bar2 - bar2

		DrawHUDBox( x, y, w, h )

		barW = math.ceil( w * ( StaminaBar / self:GetMaxStamina() ) )
		if ( self:GetStamina() <= 1 && barW <= 1 ) then barW = 0 end
		draw.RoundedBox( 0, x, y, barW, h, Color( 155, 155, 155, 255 ) )

		draw.SimpleText( "STAMINA: " .. math.floor( self:GetStamina() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	end
	----------------------------------- Force Icons -----------------------------------
	if !wOS.ForceSelectMenu then
		y = y - icon - gap
		h = icon

		for id, t in pairs( ForcePowers ) do
			local x = x + ( id - 1 ) * ( h + gap )
			local x2 = math.floor( x + icon / 2 )

			local image = wOS.ForceIcons[ self.ForcePowers[ id ].name ]
			DrawHUDBox( x, y, h, h, self:GetForceType() == id )
			if !wOS.DisableForceIcons then
				if image then
					surface.SetMaterial( image )
					surface.SetDrawColor( Color(255, 255, 255, 255) );
					surface.DrawTexturedRect( x, y, h, h )
				end
			end
			draw.SimpleText( t.icon or "", "SelectedForceType", x2, math.floor( y + icon / 2 ), Color( 255, 255, 255 ), 1, 1 )
			if ( self.ForceSelectEnabled ) then
				draw.SimpleText( ( input.LookupBinding( "slot" .. id ) or "<NOT BOUND>" ):upper(), "SelectedForceHUD", x + gap, y + gap, Color( 255, 255, 255 ) )
			end
			if ( self:GetForceType() == id ) then
			
				local cdn = self:GetForceCooldown()
				local div = self.ForcePowers[ id ].cooldown or 1
				local rat = math.Clamp( cdn/div, 0, 1 )
				draw.RoundedBox( 0, x, y + h*( 1 - rat), h, h*rat, Color( 255, 0, 0, 100 ) )
				
				local y = y + ( icon - bar )
				surface.SetDrawColor( 0, 128, 255, 255 )
				draw.NoTexture()
				surface.DrawPoly( {
					{ x = x2 - bar, y = y },
					{ x = x2, y = y - bar },
					{ x = x2 + bar, y = y }
				} )
				draw.RoundedBox( 0, x, y, h, bar, Color( 0, 128, 255, 255 ) )
			end
		end
	end
	----------------------------------- Force Description -----------------------------------

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )

	if ( selectedForcePower && self.ForceSelectEnabled ) then

		surface.SetFont( "SelectedForceHUD" )
		local tW, tH = surface.GetTextSize( selectedForcePower.description or "" )

		--[[local x = x + w + gap
		local y = y]]
		local x = ScrW() / 2 + gap-- - tW / 2
		local y = y - tH - gap * 3

		DrawHUDBox( x, y, tW + gap * 2, tH + gap * 2 )

		for id, txt in pairs( string.Explode( "\n", selectedForcePower.description or "" ) ) do
			draw.SimpleText( txt, "SelectedForceHUD", x + gap, y + ( id - 1 ) * ScreenScale( 6 ) + gap, Color( 255, 255, 255 ) )
		end

	end

	----------------------------------- Force Label -----------------------------------

	if wOS.ForceSelectMenu then
		surface.SetFont( "SelectedForceType" )
		local txt = selectedForcePower.name or ""
		local tW2, tH2 = surface.GetTextSize( txt )

		local x = x + w / 2 - tW2/2 - 5
		local y = y - tH2 - gap * 5 
		
		DrawHUDBox( x, y, tW2 + 10, tH2 )
		draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
		
		local cdn = self:GetForceCooldown()
		local div = selectedForcePower.cooldown or 1
		local rat = math.Clamp( cdn/div, 0, 1 )

		draw.RoundedBox( 0, x, y, ( tW2 + 10 )*rat, tH2, Color( 255, 0, 0, 100 ) )
		
	end
	
	if ( !self.ForceSelectEnabled ) then
		surface.SetFont( "SelectedForceHUD" )
		local txt = "Press " .. ( input.LookupBinding( "impulse 100" ) or "<NOT BOUND>" ):upper() .. " to toggle Force selection"
		local tW, tH = surface.GetTextSize( txt )

		local x = x + w / 2
		local y = y - tH - gap

		DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
		draw.SimpleText( txt, "SelectedForceHUD", x, y, Color( 255, 255, 255 ), 1 )

		local isGood = hook.Call( "PlayerBindPress", nil, LocalPlayer(), "this_bind_doesnt_exist", true )
		if ( isGood == true ) then
			local txt = "Some addon is breaking the PlayerBindPress hook. Send a screenshot of this error to the mod page!"
			for name, func in pairs( hook.GetTable()[ "PlayerBindPress" ] ) do txt = txt .. "\n" .. tostring( name ) end
			local tW, tH = surface.GetTextSize( txt )

			y = y - tH - gap

			local id = 1
			DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
			draw.SimpleText( string.Explode( "\n", txt )[ 1 ], "SelectedForceHUD", x, y + 0, Color( 255, 230, 230 ), 1 )

			for str, func in pairs( hook.GetTable()[ "PlayerBindPress" ] ) do
				local clr = Color( 255, 255, 128 )
				if ( ( isstring( str ) && func( LocalPlayer(), "this_bind_doesnt_exist", true ) == true ) or ( !isstring( str ) && func( str, LocalPlayer(), "this_bind_doesnt_exist", true ) == true ) ) then
					clr = Color( 255, 128, 128 )
				end
				if ( !isstring( str ) ) then str = tostring( str ) end
				if ( str == "" ) then str = "<empty string hook>" end
				local _, lineH = surface.GetTextSize( str )
				draw.SimpleText( str, "SelectedForceHUD", x, y + id * lineH, clr, 1 )
				id = id + 1
			end
		end


		if ( self:GetIncorrectPlayerModel() != 0 ) then
			local txt = "Server is missing the player model or missing owner! Send a screenshot of this error to the mod page!\nPlayer model: " .. self.Owner:GetModel() .. " - Error Code: " .. self:GetIncorrectPlayerModel()
			local tW, tH = surface.GetTextSize( txt )

			y = y - tH - gap

			DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
			for id, str in pairs( string.Explode( "\n", txt ) ) do
				local _, lineH = surface.GetTextSize( str )
				draw.SimpleText( str, "SelectedForceHUD", x, y + ( id - 1 ) * lineH, Color( 255, 200, 200 ), 1 )
			end
		end
	end

	if ( selectedForcePower && self.ForceSelectEnabled ) then
		surface.SetFont( "SelectedForceType" )
		local txt = selectedForcePower.name or ""
		local tW2, tH2 = surface.GetTextSize( txt )

		local x = x + w / 2 - tW2 - gap * 2 --+ w / 2
		local y = y + gap - tH2 - gap * 2

		DrawHUDBox( x, y, tW2 + 10, tH2 )
		draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
	end

	----------------------------------- Force Target -----------------------------------

	self:DrawHUDTargetSelection()

end