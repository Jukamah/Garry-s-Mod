
--[[-------------------------------------------------------------------
	Lightsaber Console Commands:
		Changing forms, stances, force powers, maybe more?
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

concommand.Add( "rb655_select_force_wos", function( ply, cmd, args )
	if ( !IsValid( ply ) || !IsValid( ply:GetActiveWeapon() ) || !ply:GetActiveWeapon().IsLightsaber || !tonumber( args[ 1 ]) ) then return end
	if ply:GetNW2Bool( "IsMeditating", false ) then return end
	local wep = ply:GetActiveWeapon()
	local typ = math.Clamp( tonumber( args[ 1 ]), 1, #wep.ForcePowers )
	wep:ChangeForcePower( typ )
end )

concommand.Add( "wos_select_attacks", function( ply, cmd, args )
	if ( !IsValid( ply ) || !IsValid( ply:GetActiveWeapon() ) || !ply:GetActiveWeapon().IsLightsaber ) then return end
	if not args[1] then return end
	local wep = ply:GetActiveWeapon()
	local form = string.lower( args[1] )
	form = form:gsub( "^%l", string.upper )
	
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
	
	local index = wOS.Form.IndexedForms[ form ]
	
	if not index then return end
	if not wep.Stances[ index ] then return end

	local stance
	if args[2] then
		stance = tonumber( args[2] )
	end
	
	if stance then
		if !table.HasValue( wep.Stances[ index ], stance ) then
			stance = wep.Stances[ index ][1]	
		end
	else
		stance = wep.Stances[ index ][1]
	end
	
	wep:SetStance( stance )
	wep:SetForm( index )

end )

concommand.Add( "wos_openadminmenu", function( ply, cmd, args )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	ply:SendLua( "wOS:OpenAdminMenu()" )
end )