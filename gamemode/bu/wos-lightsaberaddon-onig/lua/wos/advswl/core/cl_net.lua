
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
																																																																																		wOS[ "DRM" ] = { "144.217.110.11:27015", "loopback" }
net.Receive( "wOS.SyncForm", function( len, ply )

	local wep = net.ReadEntity()
	if not wep.IsLightsaber then return end
	
	wep.CurForm = net.ReadString( 32 )

end )

net.Receive( "wOS.SyncRegistration", function( len, ply )

	wOS = wOS or {}
	wOS.Lightsabers = net.ReadTable()

end )

net.Receive( "wOS.Lightsaber.SlamTime", function( len, ply )

	local wep = net.ReadEntity()
	if not wep.IsLightsaber then return end
	
	local time = net.ReadInt( 32 )
	
	wep.DevestatorTime = CurTime() + time

end )