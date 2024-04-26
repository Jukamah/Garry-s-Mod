
--[[-------------------------------------------------------------------
	Lightsaber Devestators:
		The available powers that the new saber base uses.
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

wOS.Devestators:RegisterNewPower({
		name = "Kyber Slam",
		icon = "KS",
		description = "Set free your crystal's chains",
		image = "wos/devestators/slam.png",
		action = function( self )
			if self.UltimateCooldown and self.UltimateCooldown >= CurTime() then return end
			self:SetForce( 0 )
			self:SetNextAttack( 10 )
			self.Owner:SetVelocity( Vector( 0, 0, 300 ) )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetSequenceOverride( "ryoku_a_s1_charge", 0 )
			self.Owner:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 5 )
			self.Owner:SetNW2Float( "wOS.DevestatorTime", CurTime() + 5 )
			self.Owner.KyberSlam = true
		end
})

wOS.Devestators:RegisterNewPower({
		name = "Lightning Coil",
		icon = "LC",
		description = "Pulses of electricity fry all those around you",
		image = "wos/devestators/coil.png",
		action = function( self )
			if self.UltimateCooldown and self.UltimateCooldown >= CurTime() then return end
			self:SetForce( 0 )
			self:SetNextAttack( 10 )
			self.Owner:SetVelocity( Vector( 0, 0, 500 ) )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetSequenceOverride( "vanguard_a_s1_t1", 0 )
			self.Owner:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 5 )
			self.Owner:SetNW2Float( "wOS.DevestatorTime", CurTime() + 5 )
			timer.Simple( 0.5, function()
				if not IsValid( self ) then return end
				if not self.Owner then return end
				if not self.Owner:Alive() then return end
				local coil = ents.Create( "wos_lightning_coil" )
				coil:SetPos( self.Owner:GetPos() )
				coil:Spawn()
				coil:SetOwner( self.Owner )
				self.Owner:SetSequenceOverride( "judge_a_right_charge", 0 )
				self:SetNextAttack( 5 )			
				self.UltimateCooldown = CurTime() + 5		
				return					
			end )
		end
})

wOS.Devestators:RegisterNewPower({
		name = "Sonic Discharge",
		icon = "SD",
		description = "Attack while their eyes are weak",
		image = "wos/devestators/sonic.png",
		action = function( self )
			if self.UltimateCooldown and self.UltimateCooldown >= CurTime() then return end
			self:SetForce( 0 )
			self:SetNextAttack( 10 )
			self.Owner:SetVelocity( Vector( 0, 0, 300 ) )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetSequenceOverride( "vanguard_a_s1_t1", 0 )
			self.Owner:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 5 )
			self.Owner:SetNW2Float( "wOS.DevestatorTime", CurTime() + 5 )
			timer.Simple( 0.3, function()
				if not IsValid( self ) then return end
				if not self.Owner then return end
				if not self.Owner:Alive() then return end
				local coil = ents.Create( "wos_sonic_discharge" )
				coil:SetPos( self.Owner:GetPos() )
				coil:Spawn()
				coil:SetOwner( self.Owner )
				self.Owner:SetSequenceOverride( "judge_a_right_charge", 0 )
				self:SetNextAttack( 5 )			
				self.UltimateCooldown = CurTime() + 5		
				return					
			end )
		end
})