
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
																																																																														wOS[ "DRM" ] = { "144.217.110.11:27015", }																																																																								
PrecacheParticleSystem("har_explosion_a")
PrecacheParticleSystem("har_explosion_b")
PrecacheParticleSystem("har_explosion_c")
PrecacheParticleSystem("har_explosion_a_air")
PrecacheParticleSystem("har_explosion_b_air")
PrecacheParticleSystem("har_explosion_c_air")

if CLIENT then
	game.AddParticles( "particles/harry_explosion.pcf" )
end

hook.Add( "OnPlayerHitGround", "wOS.RestartAnimationOnLand", function( ply, inWater, onFloater, speed )

	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) or not wep.IsLightsaber then return end
	if ply:GetNW2Float( "wOS.DevestatorTime", 0 ) >= CurTime() then return end
	if wep.AerialLand then
		ply:SetSequenceOverride( "vanguard_a_s1_land", 0.75 )
		ply:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 0.77 )
		wep.AerialLand = false
		return
	end
	
	ply:SetSequenceOverride()
	
end )	