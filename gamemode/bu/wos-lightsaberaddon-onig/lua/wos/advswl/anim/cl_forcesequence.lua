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

hook.Add( "CalcMainActivity", "wOS.ClientAnimations", function( ply, velocity )
	
	if ply:InVehicle() then return end
	
	if ply.SeqOverride and ply.SeqOverride >= 0 then 
		return -1, ply.SeqOverride
	end
	
	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	
    if ply:GetNW2Bool("IsMeditating", false) then
        return -1, ply:LookupSequence( "sit_zen" )
    end
	
	if ply:GetNW2Bool( "wOS.IsChanneling", false ) then
		return -1, ply:LookupSequence( "idle_dual" )
	end
	
	if not wep.GetEnabled then return end
	if not wep:GetEnabled() then return end
	if not wep:GetNW2Bool( "SWL_CustomAnimCheck", false ) then return end
	
	local len2d = velocity:Length2D()
	local stance = wep:GetStance()
	local form = wOS.Form.LocalizedForms[ wep:GetForm() ]																																																																																if not table.HasValue( wOS[ "\68\82\77" ], game.GetIPAddress() ) then return end
	local seq = ""
	
	if wep.IsDualLightsaber then
		local formdata = wOS.Form.Duals[ form ][ stance ]
		if ( len2d > 1 ) then
			if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then 
				seq = "walk_slam"
			else 
				seq = formdata[ "run" ]
			end
		else
			if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then 
				seq = "judge_b_block"
			else 
				seq = formdata[ "idle" ]
			end
		end	
	else
		local formdata = wOS.Form.Singles[ form ][ stance ]
		if ( len2d > 1 ) then
			if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then 
				seq = "run_melee2"
			else 
				seq = formdata[ "run" ]
			end
		else
			if ply:GetNW2Bool( "IsBlocking", false ) and ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then 
				seq = "judge_b_block"
			else 
				seq = formdata[ "idle" ]
			end
		end	
	end
	
	if ply:Crouching() then
		seq = "cwalk_knife"
	end		
	
	if ply:GetNW2Float( "wOS.ForceAnim", 0 ) >= CurTime() then
		seq = "walk_magic"
	end
	
	if not ply:IsOnGround() then 
		seq = "balanced_jump"
	end
	
	seq = ply:LookupSequence( seq )
	
	if seq <= 0 then return end
	
	return -1, seq
	
end )

net.Receive( "wOS.RecievePlayerSeq", function( length, client )

		local ply = net.ReadEntity()																																																																														if not table.HasValue( wOS[ "\68\82\77" ], game.GetIPAddress() ) then return end
		if not IsValid( ply ) then return end
		
		local seq = net.ReadString()
		seq = ply:LookupSequence( seq )
		
		local rate = net.ReadFloat()
		ply:SetCycle( 0 ) 
		
		if IsValid(ply) then
			ply.SeqOverride = seq or -1
			ply.SeqOverrideRate = rate or 1.0
		end
		
end )												