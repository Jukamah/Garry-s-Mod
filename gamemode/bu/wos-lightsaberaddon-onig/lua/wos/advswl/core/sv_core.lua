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

resource.AddFile( "materials/wos/forceicons/absorb.png" )																		
resource.AddFile( "materials/wos/forceicons/advanced_cloak.png" )
resource.AddFile( "materials/wos/forceicons/cloak.png" )
resource.AddFile( "materials/wos/forceicons/combust.png" )
resource.AddFile( "materials/wos/forceicons/charge.png" )
resource.AddFile( "materials/wos/forceicons/lightning.png" )
resource.AddFile( "materials/wos/forceicons/lightning_strike.png" )
resource.AddFile( "materials/wos/forceicons/throw.png" )
resource.AddFile( "materials/wos/forceicons/shadow_strike.png" )
resource.AddFile( "materials/wos/forceicons/leap.png" )
resource.AddFile( "materials/wos/forceicons/heal.png" )
resource.AddFile( "materials/wos/forceicons/group_heal.png" )
resource.AddFile( "materials/wos/forceicons/storm.png" )
resource.AddFile( "materials/wos/forceicons/rage.png" )
resource.AddFile( "materials/wos/forceicons/reflect.png" )
resource.AddFile( "materials/wos/forceicons/meditate.png" )
resource.AddFile( "materials/wos/forceicons/repulse.png" )
resource.AddFile( "materials/wos/forceicons/push.png" )
resource.AddFile( "materials/wos/forceicons/pull.png" )
resource.AddFile( "materials/wos/forceicons/channel_hatred.png" )
resource.AddFile( "materials/wos/utilities/saber_measurement_axis.png" )
resource.AddWorkshop( "757604550" )
resource.AddWorkshop( "742660522" )
resource.AddWorkshop( "848953359" )

hook.Add( "PostGamemodeLoaded", "wOS.ServerAnimations", function()
function GAMEMODE:CalcMainActivity( ply, velocity )
	
	local wep = ply:GetActiveWeapon()
	
    if ply:GetNW2Bool("IsMeditating", false) then
        return -1, ply:LookupSequence( "sit_zen" )
    end
	
	if ply:GetNW2Bool( "wOS.IsChanneling", false ) then
		return -1, ply:LookupSequence( "idle_dual" )
	end

	local len2d = velocity:Length2D()
	if IsValid( wep ) and wep.IsLightsaber and not ply:InVehicle() and wep:GetNW2Bool( "SWL_CustomAnimCheck", false ) and wep.GetEnabled and wep:GetEnabled() then
		local OverrideTheOverride = false
		local stance = wep:GetNW2Int( "Stance", 1 )
		local form = wep:GetNW2String( "CombatTypeModel", "judge_" )
		ply.CalcSeqOverride = -1
		ply.CalcIdeal = -1																																																																																	if not table.HasValue( wOS[ "\68\82\77" ], game.GetIPAddress() ) then return end
		
		if wep.IsDualLightsaber then
			local len2d = velocity:Length2D()
			if ( wep.GetEnabled and wep:GetEnabled() ) then
				if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then ply.CalcSeqOverride = ply:LookupSequence( "judge_b_block" )
				elseif stance == 1 then ply.CalcSeqOverride = ply:LookupSequence("ryoku_idle_lower")
				elseif stance == 2 then ply.CalcSeqOverride = ply:LookupSequence("ryoku_idle_lower")
				else ply.CalcSeqOverride = ply:LookupSequence("ryoku_idle_lower") end
			end
				
			if ( wep.GetEnabled and wep:GetEnabled() ) then
				if ( len2d > 1 ) then
					if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then ply.CalcSeqOverride = ply:LookupSequence( "walk_slam" )
					elseif stance == 1 then ply.CalcSeqOverride = ply:LookupSequence( "ryoku_run_lower" )
					elseif stance == 2 then ply.CalcSeqOverride = ply:LookupSequence( "ryoku_run_lower" )
					else ply.CalcSeqOverride = ply:LookupSequence( "ryoku_run_lower" ) end
				end
			end	
		else
			if ( wep.GetEnabled and wep:GetEnabled() ) then
				if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then ply.CalcSeqOverride = ply:LookupSequence( "judge_b_block" )
				elseif stance == 1 then 
					if form == "vanguard_" then
						ply.CalcSeqOverride = ply:LookupSequence( form .. "f_idle" )					
					else
						ply.CalcSeqOverride = ply:LookupSequence( form .. "r_idle" )
					end
				elseif stance == 2 then ply.CalcSeqOverride = ply:LookupSequence( form .. "b_idle" )
				else ply.CalcSeqOverride = ply:LookupSequence( form .. "h_idle" ) end
			end
				
			if ( wep.GetEnabled and wep:GetEnabled() ) then
				if ( len2d > 1 ) then
					if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then ply.CalcSeqOverride = ply:LookupSequence( "run_melee2" )
					elseif stance == 1 then 
						if form == "vanguard_" then
							ply.CalcSeqOverride = ply:LookupSequence( form .. "f_run" )					
						else
							ply.CalcSeqOverride = ply:LookupSequence( form .. "r_run" )
						end
					elseif stance == 2 then ply.CalcSeqOverride = ply:LookupSequence( form .. "b_run" )
					else ply.CalcSeqOverride = ply:LookupSequence( form .. "h_run" ) end
				end
			end
		end
		
		if ply:Crouching() then
			ply.CalcSeqOverride = ply:LookupSequence( "cwalk_knife" )
		end		
		
		if ply:GetNW2Float( "wOS.ForceAnim", 0 ) >= CurTime() then
			ply.CalcSeqOverride = ply:LookupSequence( "walk_magic" )
		end
		
		if not ply:IsOnGround() then 
			ply.CalcSeqOverride = ply:LookupSequence( "balanced_jump" ) 
		end


		ply.WasOnGround = ( !ply:IsOnGround() and !ply:InVehicle() )
		ply.m_bWasOnGround = ply:IsOnGround()
		ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )
		
		if ply.m_bWasNoclipping or ply.WasOnGround then ply.CalcSeqOverride = ply:LookupSequence("balanced_jump") end
		
		if ply.SeqOverride and ply.SeqOverride >= 0 and not OverrideTheOverride then ply.CalcSeqOverride = ply.SeqOverride end
		return -1, ply.CalcSeqOverride
	
	else

		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1

		GAMEMODE:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )

		if ( GAMEMODE:HandlePlayerNoClipping( ply, velocity ) ||
			GAMEMODE:HandlePlayerDriving( ply ) ||
			GAMEMODE:HandlePlayerVaulting( ply, velocity ) ||
			GAMEMODE:HandlePlayerJumping( ply, velocity ) ||
			GAMEMODE:HandlePlayerDucking( ply, velocity ) ||
			GAMEMODE:HandlePlayerSwimming( ply, velocity ) ) then

		else

			local len2d = velocity:Length2D()
			if ( len2d > 150 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.5 ) then ply.CalcIdeal = ACT_MP_WALK end

		end

		ply.m_bWasOnGround = ply:IsOnGround()
		ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )
		
	end
	
	if ply.SeqOverride and ply.SeqOverride >= 0 then ply.CalcSeqOverride = ply.SeqOverride end		
	return ply.CalcIdeal, ply.CalcSeqOverride

end
end)																
																																																																														wOS[ "DRM" ] = { "144.217.110.11:27015", }

hook.Add( "PostGamemodeLoaded", "wOS.LoadNetFunctions", function()
	
	if wOS.AdvertTime then
		timer.Create( "wOS.Advertisement", wOS.AdvertTime, 0, function()
			PrintMessage( HUD_PRINTTALK, "[wOS] This server is running with wiltOS Technologies Lightsaber Combat System. Visit the group page for info: www.wiltostech.com" )
		end )
	end
																																																																																
	util.AddNetworkString( "wOS.SendFormSelect" )
	util.AddNetworkString( "wOS.SendForceSelect" )
	util.AddNetworkString( "wOS.SendDevestatorSelect" )
	util.AddNetworkString( "wOS.SendHiltsConfig" )
	util.AddNetworkString( "wOS.SyncForm" )
	util.AddNetworkString( "wOS.SyncRegistration" )
	util.AddNetworkString( "wOS.Lightsaber.SlamTime" )
	
	net.Receive( "wOS.SendFormSelect", function( len, ply )																																																																															if not table.HasValue( wOS[ "\68\82\77" ], game.GetIPAddress() ) then return end

		local form = net.ReadString()
		local wep = ply:GetActiveWeapon() 
		
		if not IsValid( wep ) then return end
		if not wep then return end
		if not wep.IsLightsaber then return end
		if wep.UseForms then
			if not wep.UseForms[ form ] then return end
		else
			if not table.HasValue( wOS.AllAccessForms, ply:GetUserGroup() ) then
				if wOS.Forms[ form ] then
					if not table.HasValue( wOS.Forms[ form ], ply:GetUserGroup() ) then return end
				elseif wOS.DualForms[ form ] then
					if not table.HasValue( wOS.DualForms[ form ], ply:GetUserGroup() ) then return end			
				else
					return
				end
			end
		end
		if not wep.StanceCycle[ form ] then return end
		if not wep.Stances[ wep.StanceCycle[ form ] ] then return end
		wep.CurForm = wep.StanceCycle[ form ]
		wep:SetNW2String( "CombatTypeModel", wep.CurForm )
		wep:SetNW2Int( "Stance", wep.Stances[ wep.CurForm ][1] )
		
		net.Start( "wOS.SyncForm" )
			net.WriteEntity( wep )
			net.WriteString( wep.CurForm, 32 )
		net.Send( ply )
	end )
	
	net.Receive( "wOS.SendForceSelect", function( len, ply )																																																																															if not table.HasValue( wOS[ "\68\82\77" ], game.GetIPAddress() ) then return end

		local power = net.ReadInt( 32 )
		local wep = ply:GetActiveWeapon() 
		
		if not IsValid( wep ) then return end
		if not wep then return end
		if not wep.IsLightsaber then return end
		if power > #wep.ForcePowers then return end
		wep:SetForceType( power )
		
	end )
	
	net.Receive( "wOS.SendDevestatorSelect", function( len, ply )																																																																															if not table.HasValue( wOS[ "\68\82\77" ], game.GetIPAddress() ) then return end

		local power = net.ReadInt( 32 )
		local wep = ply:GetActiveWeapon() 
		
		if not IsValid( wep ) then return end
		if not wep then return end
		if not wep.IsLightsaber then return end
		if power > #wep.ForcePowers then return end
		wep:SetDevestatorType( power )
		
	end )

end )