
--[[-------------------------------------------------------------------
	Lightsaber Combat Hooks:
		All the combat related hooks so we don't clog up the base hooks.
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

wOS.LightsaberHook = {}

wOS.LightsaberHook.HeavyCharge = function( self )
	
	local ply = self.Owner
	if self.HeavyCoolDown then 
		if self.HeavyCoolDown >= CurTime() then return end
	end
	if wOS.EnableStamina then
		if not self.Owner:CanUseStamina( true ) then return end
	end
	if ply.IsBlocking or !ply:IsOnGround() then return end
	if !self.HeavyCharge then return end
	if ( !ply:KeyDown( IN_ATTACK2 ) && !ply:KeyReleased( IN_ATTACK2 ) ) then return end
	
	local stance = self:GetStance()
	local form = wOS.Form.LocalizedForms[ self:GetForm() ]
	
	if not form then 
		print( "[wOS] Invalid form! Animations will not operate properly!"  )
		return 
	end
	
	local formdata
	
	if self.IsDualLightsaber then
		formdata = wOS.Form.Duals[ form ][ stance ]
	else
		formdata = wOS.Form.Singles[ form ][ stance ]
	end
	
	local movedata = formdata[ "heavy_charge" ]

	if !self.CanMoveWhileAttacking then
		self.Owner:SetLocalVelocity( Vector( 0, 0, 0 ) )
	end
	
	if ( !ply:KeyReleased( IN_ATTACK2 ) ) then
		if self.HeavyCharge <= 0 then 
			self.HeavyChargeMul = 0
			self.Owner:SetSequenceOverride( movedata, 0 )
			self.HeavyCharge = CurTime() + 9.5
		end

		self.HeavyChargeMul = math.min( self.HeavyCharge + 0.05 * 67 * FrameTime(), 2 )

		if self.HeavyCharge < CurTime() then
			self.HeavyCharge = nil
			self:PerformHeavyAttack()	
			return
		end
	else
		self.HeavyChargeMul = self.HeavyCharge
		self.HeavyCharge = nil
		self:PerformHeavyAttack()		
	end
	
end

wOS.LightsaberHook.Devestator = function( self )

	if self:GetDevEnergy() < 100 then return end
	if self.UltimateCooldown and self.UltimateCooldown >= CurTime() then return end
	local devestator = self:GetActiveDevestatorType( self:GetDevestatorType() )
	if !devestator then return end
	if self.UltimateCooldown >= CurTime() then return end
	
	if ( devestator.action ) then
		self:SetDevEnergy( 0 )
		devestator.action( self )
	end		
	
end