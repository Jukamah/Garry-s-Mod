
wOS = wOS or {}
wOS.ReactiveCycleAnimations = {}
wOS.ReactiveCycleAnimations[ HITGROUP_GENERIC ] = "h_reaction_upper"
wOS.ReactiveCycleAnimations[ HITGROUP_HEAD ] = "h_reaction_upper"
wOS.ReactiveCycleAnimations[ HITGROUP_CHEST ] = "h_reaction_upper"
wOS.ReactiveCycleAnimations[ HITGROUP_STOMACH ] = "h_reaction_lower"
wOS.ReactiveCycleAnimations[ HITGROUP_RIGHTARM ] = "h_reaction_left"
wOS.ReactiveCycleAnimations[ HITGROUP_LEFTARM  ] = "h_reaction_right"
wOS.ReactiveCycleAnimations[ HITGROUP_RIGHTLEG ] = "h_reaction_lower_left"
wOS.ReactiveCycleAnimations[ HITGROUP_LEFTLEG ] = "h_reaction_lower_right"

function rb655_DrawHit_wos( pos, dir )
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	effectdata:SetNormal( dir )
	util.Effect( "StunstickImpact", effectdata, true, true )

	--util.Decal( "LSScorch", pos + dir, pos - dir )
	util.Decal( "FadingScorch", pos + dir, pos - dir )
end

hook.Add( "AllowPlayerPickup", "rb655_lightsaber_prevent_use_pickup_wOS", function( ply, ent )
	if ( ent:GetClass() == "ent_lightsaber" ) then return false end
end )

-- -------------------------------------------------- "Slice" or kill sounds -------------------------------------------------- --

local function DoSliceSound( victim, inflictor )
	if ( !IsValid( victim ) or !IsValid( inflictor ) ) then return end
	if ( string.find( inflictor:GetClass(), "_lightsaber" ) ) then
		victim:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 5 ) .. ".wav" )
	end
end

hook.Add( "EntityTakeDamage", "rb655_lightsaber_kill_snd_wOS", function( ent, dmg )
	if ( !IsValid( ent ) or !dmg or ent:IsNPC() or ent:IsPlayer() ) then return end
	if ( ent:Health() > 0 && ent:Health() - dmg:GetDamage() <= 0 ) then
		local infl = dmg:GetInflictor()
		if ( !IsValid( infl ) && IsValid( dmg:GetAttacker() ) && dmg:GetAttacker().GetActiveWeapon ) then -- Ugly fucking haxing workaround, thanks VOLVO
			infl = dmg:GetAttacker():GetActiveWeapon()
		end
		DoSliceSound( ent, infl )
	end
end )

hook.Add( "PlayerDeath", "rb655_lightsaber_kill_snd_ply_wOS", function( victim, inflictor, attacker )
	if ( !IsValid( inflictor ) && IsValid( attacker ) && attacker.GetActiveWeapon ) then inflictor = attacker:GetActiveWeapon() end -- Ugly fucking haxing workaround, thanks VOLVO
	DoSliceSound( victim, inflictor )
end )

hook.Add( "OnNPCKilled", "rb655_lightsaber_kill_snd_npc_wOS", function( victim, attacker, inflictor )
	if ( !IsValid( inflictor ) && IsValid( attacker ) && attacker.GetActiveWeapon ) then inflictor = attacker:GetActiveWeapon() end -- Ugly fucking haxing workaround, thanks VOLVO
	DoSliceSound( victim, inflictor )
end )

-- -------------------------------------------------- Lightsaber Damage -------------------------------------------------- --

local cvar
if ( SERVER ) then
	cvar = CreateConVar( "rb655_lightsaber_allow_knockback", "1" )
end

local function IsKickbackAllowed()
	if ( cvar && cvar:GetBool() ) then return true end
	return false
end

-- A list of entities that we should not even try to deal damage to, due to them not taking dealt damage
local rb655_ls_nodamage = {
	npc_rollermine = true, -- Sigh, Lua could use arrays
	npc_turret_floor = true,
	npc_combinedropship = true,
	npc_helicopter = true,
	monster_tentacle = true,
	monster_bigmomma = true,
}

function rb655_LS_DoDamage_wos( tr, wep )
	local ent = tr.Entity
	local ply = wep.Owner
	
	if ( !IsValid( ent ) or ( ent:Health() <= 0 && ent:GetClass() != "prop_ragdoll" ) or rb655_ls_nodamage[ ent:GetClass() ] ) then return end

	if ( !IsValid( ent ) or ( ent:Health() <= 0 && ent:GetClass() != "prop_ragdoll" ) or rb655_ls_nodamage[ ent:GetClass() ] ) then return end
		if ply:IsPlayer() then
			if ply:GetActiveWeapon().IsLightsaber then
				if ply:GetNW2Float( "BlockTime", 0 ) >= CurTime() then
					if ply:GetActiveWeapon():GetEnabled() then
						return
					end
				end
			end
		end
	if wep:GetClass() == "ent_lightsaber_thrown" then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( 100 )
		dmginfo:SetDamageForce( tr.HitNormal * -13.37 )
		if !wep.CanKnockback then
			dmginfo:SetDamageForce( tr.HitNormal * 0 )	
		end
		if ( !ent:IsPlayer() || !ent:IsWeapon() ) then
			// This causes the damage to apply force the the target, which we do not want
			// For now, only apply it to the SENT
			dmginfo:SetInflictor( wep )
		end
		if ( ent:GetClass() == "npc_zombie" || ent:GetClass() == "npc_fastzombie" ) then
			dmginfo:SetDamageType( bit.bor( DMG_SLASH, DMG_CRUSH ) )
			dmginfo:SetDamageForce( tr.HitNormal * 0 )
		end
		if ( !IsValid( wep.Owner ) ) then
			dmginfo:SetAttacker( wep )
		else
			dmginfo:SetAttacker( wep.Owner )
			if wep.Owner:GetNW2Float( "RageTime", 0 ) >= CurTime() then
				dmginfo:ScaleDamage( 1.2 )
			end
		end

		ent:TakeDamageInfo( dmginfo )
		if IsValid( ent ) then
			ent:SetLocalVelocity( Vector( 0, 0, 0 ) )
		end
		return
	end
	
	local dmg = hook.Run( "CanLightsaberDamageEntity", ent, wep, tr )
	if ( isbool( dmg ) && dmg == false ) then return end

		local CanBlock = false
		if wep:IsWeapon() then
			local angle = ( ply:GetPos() - ent:GetPos() ):Angle()
			CanBlock = ( math.AngleDifference( ent:EyeAngles().y, angle.y ) <= 35 ) and ( math.AngleDifference( ent:EyeAngles().y, angle.y ) >= -35 )
		end

		if ( !IsValid( ent ) || ( ent:Health() <= 0 && ent:GetClass() != "prop_ragdoll" ) || rb655_ls_nodamage[ ent:GetClass() ] ) then return end	
		
		if ent.Hitstun then return end
		if ply.Hitstun then return end
		
		if ent:IsPlayer() then
			if ent:GetActiveWeapon().IsLightsaber then
				if ent:GetNW2Float( "BlockTime", 0 ) >= CurTime() then
					if ent:GetActiveWeapon():GetEnabled() then
						if CanBlock then
							if wOS.EnableStamina then
								local ded = 10
								if ply:GetNW2Float( "SWL_HeavyAttackTime", 0 ) >= CurTime() then
									ded = 30
								end
								if ent:GetActiveWeapon():GetStamina() >= ded then
									local time = ent:SetSequenceOverride( "h_block", 0.5 )
									ent:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
									ent:GetActiveWeapon():AddStamina( -1*ded )
									if !ent:KeyDown( IN_ATTACK ) or ded > 15 then
										ent:GetActiveWeapon():SetNextAttack( 0.5 )
										ent:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + (ent:GetActiveWeapon():GetNextPrimaryFire() - CurTime()) - 0.2 )
									else
										local time = ply:SetSequenceOverride( "h_forward_riposte", 1, 0.25 )
										if not time then time = 0.5 end
										ply:GetActiveWeapon():SetNextAttack( time )
										ply:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + time )										
									end
									ent:SetNW2Float( "BlockTime", CurTime() + 0.6 ) 
								else
									ent:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 1 )
									CanBlock = false
								end
							else
								local ded = 10
								if ply:GetNW2Float( "SWL_HeavyAttackTime", 0 ) >= CurTime() then
									ded = 30
								end
								if ent:GetActiveWeapon():GetForce() >= ded then
									local time = ent:SetSequenceOverride( "h_block", 0.5 )
									ent:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
									ent:GetActiveWeapon():SetForce( ent:GetActiveWeapon():GetForce() - ded )
									if !ent:KeyDown( IN_ATTACK ) or ded > 15 then
										ent:GetActiveWeapon():SetNextAttack( 0.5 )
										ent:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + (ent:GetActiveWeapon():GetNextPrimaryFire() - CurTime()) - 0.2 )
									else
										local time = ply:SetSequenceOverride( "h_forward_riposte", 1, 0.25 )
										if not time then time = 0.5 end
										ply:GetActiveWeapon():SetNextAttack( time )
										ply:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + time )										
									end
									ent:SetNW2Float( "BlockTime", CurTime() + 0.6 ) 
								else
									ent:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 1 )
									CanBlock = false
								end							
							end
							if wep.UseSkills then
								if IsValid( wep.Owner ) then
									if wep.Owner.PlayerSaberBlocks then
										for _, block in pairs( wep.Owner.PlayerSaberBlocks) do
											block( wep.Owner, ent, wep )
										end
									end
								end
							end
							return
						end
					end
				end
			end
		end
	
	local dmginfo = DamageInfo()
	dmginfo:SetDamage( wep.SaberDamage or 100 )
	
	if ( isbool( dmg ) && dmg == false ) then return end
	
	if ( ( !ent:IsPlayer() or !wep:IsWeapon() ) || IsKickbackAllowed() ) then
		-- This causes the damage to apply force the the target, which we do not want
		-- For now, only apply it to the SENT
		dmginfo:SetInflictor( wep )
	end

	if ( ent:GetClass() == "npc_zombie" or ent:GetClass() == "npc_fastzombie" ) then
		dmginfo:SetDamageType( bit.bor( DMG_SLASH, DMG_CRUSH ) )
		dmginfo:SetDamageForce( tr.HitNormal * 0 )
		dmginfo:SetDamage( math.max( dmginfo:GetDamage(), 30 ) ) -- Make Zombies get cut in half
	end

	if ( !IsValid( wep.Owner ) ) then
		dmginfo:SetAttacker( wep )
	else
		dmginfo:SetAttacker( wep.Owner )
		if wep.Owner:GetNW2Float( "SWL_HeavyAttackTime", 0 ) >= CurTime() then
			dmginfo:ScaleDamage( 1.5 )
			--dmginfo:AddDamage( wep.SaberDamage*wep.HeavyChargeMul/100 )
		end
	end
	
	if wep:GetNextPrimaryFire() < CurTime() and wep.AttackTime < CurTime() then
		dmginfo:SetDamage( wep.SaberBurnDamage or 25 )
	end
	
	if wep.UseSkills then
		if IsValid( wep.Owner ) then
			if wep.Owner.PlayerSaberSlashes then
				for _, slash in pairs( wep.Owner.PlayerSaberSlashes ) do
					slash( wep.Owner, ent, wep, dmginfo )
				end
			end
		end
	end
	
	if not IsValid(ent) then return end
	if ent:IsNPC() then ent:TakeDamageInfo( dmginfo ) ent:EmitSound( "lightsaber/saber_hit_laser5.wav", 75, 100, 0.3 ) return end
	if not ent:IsPlayer() then return end	
	if ent:Alive() then

		ent:TakeDamageInfo( dmginfo )
		if wep.CanKnockback then
			if IsValid( ent ) then
				ent:SetLocalVelocity( Vector( 0, 0, 0 ) )
			end
		end
		
		ent:EmitSound( "lightsaber/saber_hit_laser5.wav", 75, 100, 0.3 )
		ent.Hitstun = true
		timer.Simple(0.19, function() ent.Hitstun = false end)
		if wep.ShouldStun then
			local anim = wOS.ReactiveCycleAnimations[ tr.HitGroup ] or "h_reaction_upper"
			local time = ent:SetSequenceOverride( anim, 0.19 )
					
			if ent:GetActiveWeapon() and ent:GetActiveWeapon().IsLightsaber then 
				
				--ent:GetActiveWeapon():SetNextAttack(time)
				
				ent:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + (ent:GetActiveWeapon():GetNextPrimaryFire() - CurTime()) - 0.2 )
				
			end
		end
	end	
	
end

