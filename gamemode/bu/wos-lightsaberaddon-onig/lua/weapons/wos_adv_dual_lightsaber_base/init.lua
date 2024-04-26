
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

SWEP.DevCharge = 5
SWEP.AttackTime = 0

function SWEP:DoLight()

	local stance = self:GetStance()
	local form = wOS.Form.LocalizedForms[ self:GetForm() ]
	
	if not form then 
		print( "[wOS] Invalid form! Animations will not operate properly!"  )
		self:SetDelay( 0 ) 
		return 
	end
	
	local formdata = wOS.Form.Duals[ form ][ stance ]
	local movedata = formdata[ "light_forward" ]
	local time
	
	if self.Owner:KeyDown(IN_MOVELEFT) then 
		movedata = formdata[ "light_left" ]
	elseif self.Owner:KeyDown(IN_MOVERIGHT) then 
		movedata = formdata[ "light_right" ]
	end
	
	if not movedata then
		print( "[wOS] Invalid move data for form: " .. form .. "!"  )
		self:SetDelay( 0 ) 
		return 	
	end
	
	local time = self.Owner:SetSequenceOverride( movedata[ "Sequence" ], movedata[ "Time" ], movedata[ "Rate" ] ) or 0.5
	
	if wOS.EnableLunge then
		local force = self.Owner:GetAimVector() * 500 
		force.z = 0; 
		self.Owner:SetVelocity( force ) 
	end
	
	if not self.CanMoveWhileAttacking then
		self.Owner:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + time )
	end	
	
	time = time or 0.5
	self:SetDelay( time )
	self.AttackTime = CurTime() + time
	
end

function SWEP:DoAerial()

	local stance = self:GetStance()
	local form = wOS.Form.LocalizedForms[ self:GetForm() ]
	
	if not form then 
		print( "[wOS] Invalid form! Animations will not operate properly!"  )
		self:SetDelay( 0 ) 
		return 
	end
	
	local formdata = wOS.Form.Duals[ form ][ stance ]
	local movedata = formdata[ "air_forward" ]
	local time
	
	if self.Owner:KeyDown(IN_MOVELEFT) then 
		movedata = formdata[ "air_left" ]
	elseif self.Owner:KeyDown(IN_MOVERIGHT) then 
		movedata = formdata[ "air_right" ]
	end
	
	if not movedata then
		print( "[wOS] Invalid move data for form: " .. form .. "!"  )
		self:SetDelay( 0 ) 
		return 	
	end
	
	local time = self.Owner:SetSequenceOverride( movedata[ "Sequence" ], movedata[ "Time" ], movedata[ "Rate" ] ) or 0.5
	
	time = time or 0.5
	self:SetDelay( time )
	self.AttackTime = CurTime() + time
	
end

function SWEP:DataTableInit()

	self:SetBladeLength( 0 )
	self:SetBladeWidth( 2 )
	self:SetMaxLength( 42 )
	self:SetSecBladeLength( 0 )
	self:SetSecBladeWidth( 2 )
	self:SetSecMaxLength( 42 )
	self:SetSecDarkInner( false )
	self:SetDarkInner( false )
	self:SetWorksUnderwater( true )
	self:SetEnabled( true )

	self:SetOnSound( "lightsaber/saber_on" .. math.random( 1, 4 ) .. ".wav" )
	self:SetOffSound( "lightsaber/saber_off" .. math.random( 1, 4 ) .. ".wav" )
	self:SetWorldModel( "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl" )
	self:SetSecWorldModel( "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl" )	
	self:SetCrystalColor( Vector( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) ) )
	self:SetSecCrystalColor( Vector( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) ) )
	self:SetForceType( 1 )
	self:SetDevestatorType( 1 )
	self:SetForce( 100 )
	self:SetMaxForce( 100 )
	self:SetBlockDrain( 0.2 )
	self:SetForceCooldown( 0 )
	self:SetStamina( 100 )
	self:SetMaxStamina( 100 )
	
	self:NetworkVarNotify( "Force", self.OnForceChanged )
	self:NetworkVarNotify( "Enabled", self.OnEnabledOrDisabled )
	
end

function SWEP:StanceUpdate()
	self.StancePos = self.StancePos + 1
	if self.StancePos > #self.Stances[ self:GetForm() ] then
		self.StancePos = 1
	end
	self.CurStance = self.Stances[ self:GetForm() ][ self.StancePos ]
	self:SetStance( self.CurStance )
end

function SWEP:PerformHeavyAttack()

	if wOS.EnableStamina then
		if not self.Owner:CanUseStamina( true ) then return end
	end
	
	local stance = self:GetStance()
	local form = wOS.Form.LocalizedForms[ self:GetForm() ]
	
	if not form then 
		print( "[wOS] Invalid form! Animations will not operate properly!"  )
		self:SetDelay( 0 ) 
		return 
	end
	
	local formdata = wOS.Form.Duals[ form ][ stance ]
	local movedata = formdata[ "heavy" ]
	local time = self.Owner:SetSequenceOverride( movedata[ "Sequence" ], movedata[ "Time" ], movedata[ "Rate" ] ) or 2

	
	self:SetFPCamTime( CurTime() + time )
	self:SetNextAttack( time )
	self.AttackTime = CurTime() + time
	if wOS.EnableStamina then
		self:AddStamina( 0.5*self.StaminaRegenSpeed )
	end
	self.Owner:SetNW2Float( "SWL_HeavyAttackTime", CurTime() + time )
	self.HeavyCoolDown = CurTime() + time
	if not self.CanMoveWhileAttacking then
		self.Owner:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + time )
	end
end

function SWEP:SetStandard()

	local ply = self.Owner
	
	local group = ply:GetUserGroup()
	self:SetNW2Bool( "SWL_CustomAnimCheck", false )
	self.Stances = {}
	self.Forms = {}
	self.StancePos = 1
	self.FormPos = 1
	self:SetNW2Int( "Stance", 1 )
	if self.UseForms then
		for form, stances in pairs( self.UseForms ) do
			self.Forms[ #self.Forms + 1 ] = form
			local index = wOS.Form.IndexedForms[ form ]
			self:SetForm( index )
			self.Stances[ index ] = {}
			for _, num in pairs( stances ) do
				self:SetStance( num )
				table.insert( self.Stances[ index ], num )					
			end
		end
	else
		if table.HasValue( wOS.AllAccessForms, group ) then
			for form, _ in pairs( wOS.DualForms ) do
				self.Forms[ #self.Forms + 1 ] = form
				local index = wOS.Form.IndexedForms[ form ]
				self:SetForm( index )
				self.Stances[ index ] = { 1, 2, 3 }
			end		
			self:SetStance( 1 )
		else
			for form, _ in pairs( wOS.Forms ) do

				if wOS.DualForms[ form ][ group ] then
					local entry = wOS.DualForms[ form ][ group ]
					local index = wOS.Form.IndexedForms[ form ]
					self.Forms[ #self.Forms + 1 ] = form
					self:SetForm( index )					
					self.Stances[ index ] = {}
					for _, num in pairs( entry ) do
						self:SetStance( num )
						table.insert( self.Stances[ index ], num )
					end
				end
			end
		end
	end
	
	if table.Count( self.Stances ) > 0 and table.Count( self.Forms ) > 0 then
		self:SetNW2Bool( "SWL_CustomAnimCheck", true )
		self:SetNW2Int("Stance", self.Stances[ self:GetForm() ][1] )
	end
	
	timer.Simple( 0.5, function()
		if self.UseSkills then
			if not self.SkillsApplied then
				for _, deploy in ipairs( ply.PlayerSaberDeploys ) do
					deploy( self )
				end
				self.SkillsApplied = true
			end
		end
	end )
	
	self:LoadToolValues( ply )
	
end

function SWEP:ServerThoughts()

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if selectedForcePower then
	
		local time = self.Cooldowns[ selectedForcePower.name ] or 0
		time = math.max( time - CurTime(), 0 )
		self:SetForceCooldown( time )
		
		if selectedForcePower.think && !self.Owner:KeyDown( IN_USE ) then
			local ret = hook.Run( "CanUseLightsaberForcePower", self.Owner, selectedForcePower.name )
			if ( ret != false && selectedForcePower.think ) then
				selectedForcePower.think( self )
			end
		end
		
	end

	if !self.Owner.IsBlocking and self.Owner:KeyDown( IN_USE ) and self.Owner:KeyDown( IN_ATTACK2 ) and self:GetEnabled() and self:GetNW2Bool( "SWL_CustomAnimCheck", false ) and !( prone and self.Owner:IsProne() ) and !self.HeavyCharge then
		self.HeavyCharge = 0
	end
	
	if ( CLIENT ) then return true end
	
	wOS.LightsaberHook.HeavyCharge( self )

	if ( ( self.NextForce or 0 ) < CurTime() ) then
		self:SetForce( math.min( self:GetForce() + ( 0.5*self.RegenSpeed ), self:GetMaxForce() ) )
	end

	if ( !self:GetEnabled() && self:GetBladeLength() != 0 ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), 0, 2 ) )
	elseif ( self:GetEnabled() && self:GetBladeLength() != self:GetMaxLength() ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), self:GetMaxLength(), 8 ) )
	end

	if ( self:GetEnabled() && !self:GetWorksUnderwater() && self.Owner:WaterLevel() > 2 ) then
		self:SetEnabled( false )
		--self:EmitSound( self:GetOffSound() )
	end
	
	if ( !self:GetEnabled() && self:GetSecBladeLength() != 0 ) then
		self:SetSecBladeLength( math.Approach( self:GetSecBladeLength(), 0, 2 ) )
	elseif ( self:GetEnabled() && self:GetSecBladeLength() != self:GetSecMaxLength() ) then
		self:SetSecBladeLength( math.Approach( self:GetSecBladeLength(), self:GetSecMaxLength(), 8 ) )
	end

	if ( self:GetBladeLength() <= 0 ) then return end
	
	local pos, ang = self:GetSaberPosAng()
	
	local isTrace1Hit = false
	local isTrace2Hit = false
	local isTrace3Hit = false
	local isTrace4Hit = false
	
	if !wOS.MinimalLightsabers or self:GetNextPrimaryFire() >= CurTime() then
	
	-- ------------------------------------------------- DAMAGE ------------------------------------------------- --

		-- This whole system needs rework

		-- Up

		local pos, ang = self:GetSaberPosAng()
		local trace = util.TraceLine( {
			start = pos,
			endpos = pos + ang * self:GetBladeLength(),
			filter = { self, self.Owner },
			--mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
			--maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
		} )
		local traceBack = util.TraceLine( {
			start = pos + ang * self:GetBladeLength(),
			endpos = pos,
			filter = { self, self.Owner },
			--mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
			--maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
		} )

		--if ( SERVER ) then debugoverlay.Line( trace.StartPos, trace.HitPos, .1, Color( 255, 0, 0 ), false ) end

		-- When the blade is outside of the world
		if ( trace.HitSky or ( trace.StartSolid && trace.HitWorld ) ) then trace.Hit = false end
		if ( traceBack.HitSky or ( traceBack.StartSolid && traceBack.HitWorld ) ) then traceBack.Hit = false end

		self:DrawHitEffects( trace, traceBack )
		isTrace1Hit = trace.Hit or traceBack.Hit

		-- Don't deal the damage twice to the same entity
		if ( traceBack.Entity == trace.Entity && IsValid( trace.Entity ) ) then traceBack.Hit = false end

		if ( trace.Hit ) then rb655_LS_DoDamage_wos( trace, self ) end
		if ( traceBack.Hit ) then rb655_LS_DoDamage_wos( traceBack, self ) end

		-- Down

		if ( self:LookupAttachment( "blade2" ) > 0 ) then -- TEST ME
			local pos2, dir2 = self:GetSaberPosAng( 2 )
			local trace2 = util.TraceLine( {
				start = pos2,
				endpos = pos2 + dir2 * self:GetBladeLength(),
				filter = { self, self.Owner },
				--mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
				--maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
			} )
			local traceBack2 = util.TraceLine( {
				start = pos2 + dir2 * self:GetBladeLength(),
				endpos = pos2,
				filter = { self, self.Owner },
				--mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
				--maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
			} )

			if ( trace2.HitSky or ( trace2.StartSolid && trace2.HitWorld ) ) then trace2.Hit = false end
			if ( traceBack2.HitSky or ( traceBack2.StartSolid && traceBack2.HitWorld ) ) then traceBack2.Hit = false end

			self:DrawHitEffects( trace2, traceBack2 )
			isTrace2Hit = trace2.Hit or traceBack2.Hit

			if ( traceBack2.Entity == trace2.Entity && IsValid( trace2.Entity ) ) then traceBack2.Hit = false end

			if ( trace2.Hit ) then rb655_LS_DoDamage_wos( trace2, self ) end
			if ( traceBack2.Hit ) then rb655_LS_DoDamage_wos( traceBack2, self ) end

		end


		if true then
			local pos, ang = self:GetSaberSecPosAng()
			if self.Owner.DualWielded then
				pos, ang = self:GetSaberSecPosAng( nil, nil, self.Owner.DualWielded )
			end
			local trace = util.TraceLine( {
				start = pos,
				endpos = pos + ang * self:GetSecBladeLength(),
				filter = { self, self.Owner, ( self.Owner.DualWielded and self.Owner.DualWielded ) },
				//mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
				//maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
			} )
			local traceBack = util.TraceLine( {
				start = pos + ang * self:GetSecBladeLength(),
				endpos = pos,
				filter = { self, self.Owner, ( self.Owner.DualWielded and self.Owner.DualWielded ) },
				//mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
				//maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
			} )

			if ( SERVER ) then debugoverlay.Line( trace.StartPos, trace.HitPos, .1, Color( 255, 0, 0 ), false ) end

			if ( trace.HitSky || trace.StartSolid ) then trace.Hit = false end
			if ( traceBack.HitSky || traceBack.StartSolid ) then traceBack.Hit = false end

			self:DrawHitEffects( trace, traceBack )
			isTrace3Hit = trace.Hit || traceBack.Hit

			// Don't deal the damage twice to the same entity
			if ( traceBack.Entity == trace.Entity && IsValid( trace.Entity ) ) then traceBack.Hit = false end

			if ( trace.Hit ) then rb655_LS_DoDamage_wos( trace, self ) end
			if ( traceBack.Hit ) then rb655_LS_DoDamage_wos( traceBack, self ) end

			-- Down
			if ( self:GetSecWorldModel():find( "staff" ) ) then -- TEST ME
				local pos2, dir2 = self:GetSaberSecPosAng( 2 )
				local trace2 = util.TraceLine( {
					start = pos2,
					endpos = pos2 + dir2 * self:GetSecBladeLength(),
					filter = { self, self.Owner, ( self.Owner.DualWielded and self.Owner.DualWielded ) },
					//mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
					//maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
				} )
				local traceBack2 = util.TraceLine( {
					start = pos2 + dir2 * self:GetSecBladeLength(),
					endpos = pos2,
					filter = { self, self.Owner, ( self.Owner.DualWielded and self.Owner.DualWielded ) },
					//mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 8,
					//maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 8
				} )

				if ( trace2.HitSky || trace2.StartSolid ) then trace2.Hit = false end
				if ( traceBack2.HitSky || traceBack2.StartSolid ) then traceBack2.Hit = false end

				self:DrawHitEffects( trace2, traceBack2 )
				isTrace4Hit = trace2.Hit || traceBack2.Hit

				if ( traceBack2.Entity == trace2.Entity && IsValid( trace2.Entity ) ) then traceBack2.Hit = false end

				if ( trace2.Hit ) then rb655_LS_DoDamage_wos( trace2, self ) end
				if ( traceBack2.Hit ) then rb655_LS_DoDamage_wos( traceBack2, self ) end

			end
			
		end
	
	end
	
	-- ------------------------------------------------- SOUNDS ------------------------------------------------- --
	
	if ( ( isTrace1Hit or isTrace2Hit or isTrace3Hit or isTrace4Hit  ) && self.SoundHit ) then
		self.SoundHit:ChangeVolume( math.Rand( 0.1, 0.5 ), 0 )
	elseif ( self.SoundHit ) then
		self.SoundHit:ChangeVolume( 0, 0 )
	end
	
	if ( self.SoundSwing ) then

		if ( self.LastAng != ang ) then
			self.LastAng = self.LastAng or ang
			self.SoundSwing:ChangeVolume( math.Clamp( ang:Distance( self.LastAng ) / 2, 0, 1 ), 0 )
		end

		self.LastAng = ang
	end

	if ( self.SoundLoop ) then
		pos = pos + ang * self:GetBladeLength()

		if ( self.LastPos != pos ) then
			self.LastPos = self.LastPos or pos
			self.SoundLoop:ChangeVolume( 0.1 + math.Clamp( pos:Distance( self.LastPos ) / 128, 0, 0.2 ), 0 )
		end
		self.LastPos = pos
	end
	
end

function SWEP:AddForcePower( power )
	self.ForcePowers = {}
	self.AvailablePowers = table.Copy( wOS.AvailablePowers )
	if not table.HasValue( self.ForcePowerList, power ) then table.insert( self.ForcePowerList, power ) end
	for _, force in pairs( self.ForcePowerList ) do
		if not self.AvailablePowers[ force ] then continue end
		self.ForcePowers[ #self.ForcePowers + 1 ] = self.AvailablePowers[ force ]
	end
	net.Start( "wOS.SkillTree.RefreshWeapon" )
		net.WriteString( self.Class )
		net.WriteTable( self.ForcePowerList )
		net.WriteTable( self.DevestatorList )
	net.Send( self.Owner )
end

function SWEP:AddDevestator( power )
	self.Devestators = {}
	self.AvailableDevestators = table.Copy( wOS.AvailableDevestators )
	if not table.HasValue( self.DevestatorList, power ) then table.insert( self.DevestatorList, power ) end
	for _, dev in pairs( self.DevestatorList ) do
		if not self.AvailableDevestators[ dev ] then continue end
		self.Devestators[ #self.Devestators + 1 ] = self.AvailableDevestators[ dev ]
	end
	net.Start( "wOS.SkillTree.RefreshWeapon" )
		net.WriteString( self.Class )
		net.WriteTable( self.ForcePowerList )
		net.WriteTable( self.DevestatorList )
	net.Send( self.Owner )
end

function SWEP:AddForm( form, stance )
	if not wOS.Form.Duals[ form ] then return end
	local index = wOS.Form.IndexedForms[ form ]
	if not self.Stances[ index ] then self.Stances[ index ] = {} end
	if not self.UseForms[ form ] then self.UseForms[ form ] = {} end
	if not table.HasValue( self.UseForms[ form ], stance ) then table.insert( self.UseForms[ form ], stance ) end
	if not table.HasValue( self.Stances[ index ], stance ) then table.insert( self.Stances[ index ], stance ) end
	if not table.HasValue( self.Forms, form ) then table.insert( self.Forms, form ) end
	if table.Count( self.Stances ) > 0 and table.Count( self.Forms ) > 0 then
		self:SetNW2Bool( "SWL_CustomAnimCheck", true )
		self:SetForm( index )
		self:SetStance( stance )
	end
	
	net.Start( "wOS.SkillTree.RefreshForms" )
		net.WriteString( self.Class )
		net.WriteTable( self.Forms )
		net.WriteTable( self.Stances )
	net.Send( self.Owner )	
end

function SWEP:SyncPersonalData()
	net.Start( "wOS.Crafting.RefreshWeaponDual" )
		net.WriteEntity( self )
		net.WriteTable( self.CustomSettings )
		net.WriteTable( self.SecCustomSettings )
	net.Broadcast()
end

local translation_table = {
	UseHilt = "UseSecHilt",
	UseColor = "UseSecColor",
	UseDarkInner = "UseSecDarkInner",
	UseLength = "UseSecLength",
	UseWidth = "UseSecWidth",
	CustomSettings = "SecCustomSettings",
}

function SWEP:LoadToolValues( ply )
	
	if self.LoadDelay >= CurTime() then return end
	
	self:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_dual_bladel_single", 42 ), 32, 64 ) )
	self:SetSecMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_dual_bladel", 42 ), 32, 64 ) )
	self:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_dual_red_single" ), ply:GetInfo( "rb655_lightsaber_dual_green_single" ), ply:GetInfo( "rb655_lightsaber_dual_blue_single" ) ) )
	self:SetSecCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_dual_red" ), ply:GetInfo( "rb655_lightsaber_dual_green" ), ply:GetInfo( "rb655_lightsaber_dual_blue" ) ) )
	self:SetDarkInner( ply:GetInfo( "rb655_lightsaber_dual_dark_single" ) == "1" )
	self:SetSecDarkInner( ply:GetInfo( "rb655_lightsaber_dual_dark" ) == "1" )
	self:SetWorldModel( ply:GetInfo( "rb655_lightsaber_dual_model_single" ) )
	self:SetSecWorldModel( ply:GetInfo( "rb655_lightsaber_dual_model" ) )
	self:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_dual_bladew_single", 2 ), 2, 4 ) )
	self:SetSecBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_dual_bladew", 2 ), 2, 4 ) )
	
	self.LoopSound = ply:GetInfo( "rb655_lightsaber_humsound" )
	self.SwingSound = ply:GetInfo( "rb655_lightsaber_swingsound" )
	self:SetOnSound( ply:GetInfo( "rb655_lightsaber_onsound" ) )
	self:SetOffSound( ply:GetInfo( "rb655_lightsaber_offsound" ) )
	
	if not self.AppliedCrafting then
	
		if self.PersonalLightsaber then
			local default = table.Copy( wOS.DefaultPersonalSaber )
			self.SaberXPMul = 0
			for setting, value in pairs( default ) do
				self[ setting ] = value
			end
			if ply.PersonalSaber then
				for name, data in pairs( ply.PersonalSaber ) do
					data.OnEquip( self )
				end
			end
			
			local decoy = {}
			decoy.CustomSettings = {}
			
			local default2 = table.Copy( wOS.DefaultSecPersonalSaber )
			for setting, value in pairs( default2 ) do
				local id = translation_table[ setting ]
				if not id then continue end
				self[ id ] = value		
			end
			
			if ply.SecPersonalSaber then
				for name, data in pairs( ply.SecPersonalSaber ) do
					data.OnEquip( decoy )
				end
			end
			
			for name, data in pairs( ply.SaberMiscFunctions ) do
				data.OnEquip( self )
			end
			
			for trans, val in pairs( decoy ) do
				local id = translation_table[ trans ]
				if not id then continue end
				self[ id ] = val
			end
			
		end
		
		self:SetMaxForce( self.MaxForce )
		self:SetBlockDrain( self.BlockDrainRate )
		
		self.AppliedCrafting = true

	end

	if self.UseLength then
		self:SetMaxLength( self.UseLength )
	end
	if self.UseColor then
		self:SetCrystalColor( Vector( self.UseColor.r, self.UseColor.g, self.UseColor.b ) )
	end
	if self.UseDarkInner then
		self:SetDarkInner( self.UseDarkInner == 1 )
	end
	if self.UseHilt then
		self:SetWorldModel( self.UseHilt )
	end
	if self.UseWidth then
		self:SetBladeWidth( self.UseWidth )
	end
	if self.UseLoopSound then
		self.LoopSound = self.UseLoopSound
	end
	if self.UseSwingSound then
		self.SwingSound = self.UseSwingSound
	end
	if self.UseOnSound then
		self:SetOnSound( self.UseOnSound )
	end
	if self.UseOffSound then
		self:SetOffSound( self.UseOffSound )
	end
	
	if self.UseSecLength then
		self:SetSecMaxLength( self.UseSecLength )
	end
	if self.UseSecColor then
		self:SetSecCrystalColor( Vector( self.UseSecColor.r, self.UseSecColor.g, self.UseSecColor.b ) )
	end
	if self.UseSecDarkInner then
		self:SetSecDarkInner( self.UseSecDarkInner == 1 )
	end
	if self.UseSecHilt then
		self:SetSecWorldModel( self.UseSecHilt )
	end
	if self.UseSecWidth then
		self:SetSecBladeWidth( self.UseSecWidth )
	end
	
	self.LoadDelay = CurTime() + 0.5
	
	if self.PersonalLightsaber then
		self:SyncPersonalData()
	end
	
	self.WorldModel = self:GetWorldModel()
	
end

function SWEP:HandleForcePower()

	if ( !IsValid( self.Owner ) or !self:GetActiveForcePowerType( self:GetForceType() ) ) then return end
	if ( game.SinglePlayer() && SERVER ) then self:CallOnClient( "SecondaryAttack", "" ) end

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ( !selectedForcePower ) then return end

	local ret = hook.Run( "CanUseLightsaberForcePower", self.Owner, selectedForcePower.name )
	if ( ret == false ) then return end

	if self.Cooldowns then
		if self.Cooldowns[ selectedForcePower.name ] then 
			if self.Cooldowns[ selectedForcePower.name ] >= CurTime() then return end
		end
	end
	
	if ( selectedForcePower.action ) then
		local success = selectedForcePower.action( self )
		if ( GetConVarNumber( "rb655_lightsaber_infinite" ) != 0 ) then self:SetForce( 100 ) end
		if selectedForcePower.cooldown and success then
			self.Cooldowns[ selectedForcePower.name ] = CurTime() + selectedForcePower.cooldown
		end
	end
	
end

function SWEP:ChangeForcePower( id )
	self:SetForceType( id )
	local selectedForcePower = self:GetActiveForcePowerType( id )
	if selectedForcePower and selectedForcePower.cooldown then
		if self.Cooldowns[ selectedForcePower.name ] then
			local time = math.max( self.Cooldowns[ selectedForcePower.name ] - CurTime(), 0 )
			self:SetForceCooldown( time )
		else
			self:SetForceCooldown( 0 )
		end	
	end
end