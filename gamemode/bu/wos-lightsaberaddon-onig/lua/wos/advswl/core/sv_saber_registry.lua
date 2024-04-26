
--[[-------------------------------------------------------------------
	Lightsaber Registry System:
		Make all those pretty effects actually work properly.
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

wOS.Lightsabers = {}
wOS.Lightsabers.Single = {}
wOS.Lightsabers.Dual = {}
wOS.Lightsabers.General = {}

function wOS:RegisterLightsaber( class, dual )
	if dual then
		wOS.Lightsabers.Dual[ class ] = true
	else
		wOS.Lightsabers.Single[ class ] = true	
	end
	wOS.Lightsabers.General[ class ] = true	
	
	net.Start( "wOS.SyncRegistration" )
		net.WriteTable( self.Lightsabers )
	net.Broadcast()
	
end

--Don't know what you expected here. Maybe there'll be more later on? IDK!