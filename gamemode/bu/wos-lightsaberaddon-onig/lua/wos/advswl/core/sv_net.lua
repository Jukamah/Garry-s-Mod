
--[[-------------------------------------------------------------------
	Advanced Combat System Core Net Functions:
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
hook.Add( "PostGamemodeLoaded", "wOS.LoadNetFunctions", function()
																																																																												
	util.AddNetworkString( "wOS.SendFormSelect" )
	util.AddNetworkString( "wOS.SendForceSelect" )
	util.AddNetworkString( "wOS.SendDevestatorSelect" )
	util.AddNetworkString( "wOS.SendHiltsConfig" )
	util.AddNetworkString( "wOS.SyncForm" )
	util.AddNetworkString( "wOS.SyncRegistration" )
	util.AddNetworkString( "wOS.Lightsaber.SlamTime" )
	util.AddNetworkString( "wOS.RecievePlayerSeq" )
	
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

		local index = wOS.Form.IndexedForms[ form ]
		if not index then return end
		if not wep.Stances[ index ] then return end

		wep:SetForm( index )
		wep:SetStance( wep.Stances[ index ][1] )
	
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