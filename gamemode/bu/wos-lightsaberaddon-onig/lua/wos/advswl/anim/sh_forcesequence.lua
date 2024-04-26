
--[[-------------------------------------------------------------------
	Lightsaber Force Sequencer:
		Do the cool stuff
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

local meta = FindMetaTable("Player")

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

function meta:SetSequenceOverride( seq, time, rate )

	if !seq then 
		if SERVER then
			self:SequenceOverride(-1); timer.Destroy("SequenceEnd".. self:SteamID64() ) 
		end
		return 
	end
	
	if !time then 
		time = self:SequenceDuration( self:LookupSequence( seq ) ) - 0.35 
	end
	
	if SERVER then
		self:SequenceOverride( seq, rate or 1 )
		timer.Destroy("SequenceEnd" .. self:SteamID64())
		if time > 0 then
			timer.Create("SequenceEnd" .. self:SteamID64(), time, 1, function() self:SequenceOverride(-1); timer.Destroy("SequenceEnd" .. self:SteamID64()) end)
		end		
	end
	
	self:SetCycle(0)
	
	return time
	
end

hook.Add( "UpdateAnimation", "wOS.SharedAnimations", function( ply, velocity, maxseqgroundspeed )

	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local rate = math.min( movement, 1 )
	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end
	
	ply:SetPlaybackRate( ply.SeqOverrideRate or rate )
	return true
	
end )