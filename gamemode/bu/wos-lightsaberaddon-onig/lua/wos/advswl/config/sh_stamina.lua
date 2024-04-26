--[[-------------------------------------------------------------------
	Lightsaber Stamina System:
		Make the right choices and play smart.
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


if not wOS then
	wOS = {}
end

-- Enable the stamina mod?
wOS.EnableStamina = false

if not wOS.EnableStamina then return end

-- Amount of stamina lost when doing a normal attack ( Out of 100 )
wOS.AttackCost = 15

-- Amount of stamina lost when doing a heavy attack ( Out of 100 )
wOS.HeavyCost = 35

hook.Add( "InitPostEntity", "wOS.LoadStaminaFuncs", function()

	local meta = FindMetaTable( "Player" )
	
	function meta:CanUseStamina( heavy )
		if not IsValid( self:GetActiveWeapon() ) then return false end
		if not self:GetActiveWeapon().IsLightsaber then return false end
		local stam = wOS.AttackCost
		if heavy then
			stam = wOS.HeavyCost
		end
		if self:GetActiveWeapon():GetStamina() < stam then return false end
		
		return true
	end

end )