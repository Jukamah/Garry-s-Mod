
--[[-------------------------------------------------------------------
	Lightsaber Combat System:
		An intuitively designed lightsaber combat system.
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

hook.Add( "PostGamemodeLoaded", "wOS.AddJobsForForms", function()

-- This is where you configure the group that has access to the form, and which stance they will be using.
-- FORMAT: wOS.Forms[ FORM ] = { [ ULXGROUP ] = { STANCENUMBER1, STANCENUMBER2, STANCENUMBER3 } }
-- STANCENUMBER is a number from 1-3
-- And follow through
-- PLEASE NOTE THAT IF A GROUP DOES NOT HAVE A FORM SPECIFIED, THEY WILL JUST USE THE DEFAULT GMOD ANIMATIONS!


--This is where you'd select the usergroups that should have access to ALL forms and stances!
wOS.AllAccessForms = { "superadmin", "admin", "senioradmin", "headadmin", "founder", "seniormoderator", "moderator", "gamemaster", "staffmanager", "VIP", "user" }

end )