
--[[-------------------------------------------------------------------
	Lightsaber Base Hooks:
		Getting the normal saber functionality on our base.
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

hook.Add( "ScalePlayerDamage", "TakeNoDamageWhileBlockING_WOS", function( ent, hitgroup, dmginfo )
	if not ent:IsPlayer() then return end
	local wep = ent:GetActiveWeapon()
	if ( IsValid( ent ) && IsValid( wep ) && wep.IsLightsaber ) then
		if ent:GetNW2Float( "BlockTime", 0 ) >= CurTime() then
			if dmginfo:IsDamageType( DMG_BULLET ) || dmginfo:IsDamageType( DMG_SHOCK ) then
				local att = dmginfo:GetAttacker()
				local angle = ( att:GetPos() - ent:GetPos() ):Angle()
				if ( math.AngleDifference( angle.y, ent:EyeAngles().y ) <= 35 ) and ( math.AngleDifference( angle.y, ent:EyeAngles().y ) >= -35 ) then 
					local bullet = {}
					bullet.Num 		= 1
					bullet.Src 		= ent:EyePos()			
					bullet.Dir 		= ent:GetAimVector()
					bullet.Spread 	= 0		
					bullet.Tracer	= 1
					bullet.Force	= 0						
					bullet.Damage	= dmginfo:GetDamage()
					if bullet.Damage < 0 then bullet.Damage = bullet.Damage*-1 end
					bullet.AmmoType = "Pistol"
					bullet.TracerName = att:GetActiveWeapon().Tracer or att:GetActiveWeapon().TracerName or "Ar2Tracer"
					ent:FireBullets( bullet )
					ent:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
					dmginfo:SetDamage( 0 )
					if wOS.EnableStamina then
						wep:AddStamina( -5 )
					else
						wep:SetForce( wep:GetForce() - 5 )
					end
					ent:SetSequenceOverride( "h_block", 0.5 )
					if wep.UseSkills then
						if ent.PlayerSaberBlocks then
							for _, block in pairs( ent.PlayerSaberBlocks) do
								block( ent, att, wep )
							end
						end
					end
				end
			end
		end
	end
end )

hook.Add( "GetFallDamage", "rb655_lightsaber_no_fall_damage_wOS", function( ply, speed )
	if ( IsValid( ply ) && IsValid( ply:GetActiveWeapon() ) && ply:GetActiveWeapon().IsLightsaber ) then
		return 0
	end
end )

timer.Simple( 8, function()
	hook.Add( "EntityTakeDamage", "arb655_sabers_armor_wos", function( ply, dmg )
		if ( !ply.GetActiveWeapon || !ply:IsPlayer() ) then return end
		local wep = ply:GetActiveWeapon()
		if ( !IsValid( wep ) || !wep.IsLightsaber || wep.ForcePowers[ wep:GetForceType() ].name != "Force Absorb" ) then return end
		if ( !ply:KeyDown( IN_ATTACK2 ) /*|| !ply:IsOnGround()*/ ) then return end
		local damage = dmg:GetDamage() / 7
		dmg:SetDamage( 0 )
		local force = wep:GetForce()
		if ( force < damage ) then
			wep:SetForce( 0 )
			dmg:SetDamage( ( damage - force ) * 5 )
			return
		end
		wep:SetForce( force - damage )
	end )

	hook.Add( "EntityTakeDamage", "arb655_sabers_reflect_wos", function( ply, dmginfo )
		if ( !ply.GetActiveWeapon || !ply:IsPlayer() ) then return end
		if ply:GetNW2Float( "ReflectTime", 0 ) < CurTime() then return end
		local attacker = dmginfo:GetAttacker()
		if !IsValid( attacker ) then return end
		if !attacker:IsPlayer() then return end
		local damage = dmginfo:GetDamage()
		dmginfo:SetDamage( 0 )
		if attacker:GetNW2Float( "ReflectTime", 0 ) > CurTime() then return end
		
		local reflectdamage = DamageInfo()
		reflectdamage:SetAttacker( ply )
		reflectdamage:SetInflictor( ply:GetActiveWeapon() )
		reflectdamage:SetDamage( damage )
		attacker:TakeDamageInfo( reflectdamage )
	end )
end )

hook.Add( "PlayerDeath", "wOS.UndoMeditate", function( ply, _, _ )
	ply:SetNW2Bool( "IsMeditating", false )
	ply:SetNW2Float( "CloakTime", 0 )
	ply.KyberSlam = false
	ply:SetSequenceOverride()
end )

hook.Add( "PlayerInitialSpawn", "wOS.SyncLightsaberStuff", function( ply )

	net.Start( "wOS.SyncRegistration" )
		net.WriteTable( wOS.Lightsabers )
	net.Send( ply )

end )

hook.Add( "OnPlayerHitGround", "wOS.ActivateDevestators", function( ply, inWater, onFloater, speed )

	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) or not wep.IsLightsaber then return end
	if ply:GetNW2Float( "wOS.DevestatorTime", 0 ) < CurTime() then return end
	if ply.KyberSlam then
		local slam = ents.Create( "wos_kyber_slam" )
		slam:SetPos( ply:GetPos() )
		slam:Spawn()
		slam:SetOwner( ply )
		ply:SetSequenceOverride( "ryoku_a_s2_land", 3 )
		wep:SetNextAttack( 3 )			
		wep.UltimateCooldown = CurTime() + 5		
		ply.KyberSlam = false
		ply:EmitSound( "wos/lightsabers/forceslam.wav", nil, 50 )
		ParticleEffect( table.Random({"har_cb_explosion_a","har_cb_explosion_b"}), ply:GetPos(), Angle(0,0,0), nil )
		return
	end
	
end )