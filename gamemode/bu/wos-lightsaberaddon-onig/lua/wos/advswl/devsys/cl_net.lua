
--[[-------------------------------------------------------------------
	Lightsaber Force Power Client Net:
		All the beautiful net functions required by the forcepower system.
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
wOS.AvailableDevestators = wOS.AvailableDevestators or {}
wOS.DevestatorIcons = wOS.DevestatorIcons or {}

net.Receive( "wOS.Lightsabers.SendDevestatorData", function()
	wOS.AvailableDevestators = net.ReadTable()
	for name, data in pairs( wOS.AvailableDevestators ) do
		if data.image then
			wOS.DevestatorIcons[ name ] = Material( data.image, "unlitgeneric" )
		end
	end
end )