
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


wOS = wOS or {}

hook.Add( "PostGamemodeLoaded", "wOS.AddHiltsforJobs", function()

-- This is where you put the saber path you want to have access to. 
-- YOU MUST PUT THE PATH HERE BEFORE PUTTING THEM IN A JOB/ULX!
wOS.AllSaberModels = {
"models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_anakin_ep3_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_luke_ep6_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_mace_windu_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_maul_saber_half_hilt.mdl",
"models/sgg/starwars/weapons/w_obiwan_ep1_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_obiwan_ep3_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_quigon_gin_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_sidious_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_vader_saber_hilt.mdl",
"models/sgg/starwars/weapons/w_yoda_saber_hilt.mdl",
"models/weapons/starwars/w_kr_hilt.mdl",
"models/weapons/starwars/w_maul_saber_staff_hilt.mdl",
"models/weapons/starwars/w_dooku_saber_hilt.mdl",
}

-- The saber models you want everyone to have. It's formatted the exact same way as the above
-- EXAMPLE: wOS.DefaultSaberModels = { "models/sgg/starwars/weapons/w_mace_windu_saber_hilt.mdl", "models/sgg/starwars/weapons/w_obiwan_ep1_saber_hilt.mdl", "models/weapons/starwars/w_kr_hilt.mdl", }
wOS.DefaultSaberModels = { "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl", }

wOS.SaberGroupModels = {}
-- The saber models you want people of a particular ulx group to have access to. Same formatting as the above only this time it is wrapped in a key similar to the forms
-- You can give a group access to all sabers by doing this: wOS.SaberGroupModels[ "superadmin" ] = table.Copy( wOS.AllSaberModels )
wOS.SaberGroupModels[ "user" ] = { "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl", }
wOS.SaberGroupModels[ "superadmin" ] = table.Copy( wOS.AllSaberModels )

wOS.SaberTeamModels = {}
-- I think you get the idea of how to do this by now pal, you're a smart guy

end )