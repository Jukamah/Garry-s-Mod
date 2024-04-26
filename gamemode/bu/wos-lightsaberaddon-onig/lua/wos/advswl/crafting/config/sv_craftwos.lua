
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

--Your MySQL Data ( Fill in if you are using MySQL Database )
--DO NOT GIVE THIS INFORMATION OUT! Malicious users can connect to your database with it
wOS.CraftingDatabase = wOS.CraftingDatabase or {}
wOS.CraftingDatabase.Host = "localhost"
wOS.CraftingDatabase.Port = 3306
wOS.CraftingDatabase.Username = "root"
wOS.CraftingDatabase.Password = ""
wOS.CraftingDatabase.Database = "wos-crafting"
wOS.CraftingDatabase.Socket = ""


--How often do you want to save player crafting ( in seconds )
wOS.CraftingDatabase.SaveFrequency = 360

--Do you want to use MySQL Database to save your data?
--PlayerData ( text files in your data folder ) are a lot less intensive but lock you in on one server
--MySQL Saving lets you sync with many servers that share the database, but has the potential to increase server load due to querying
wOS.ShouldCraftingUseMySQL = false

--How long should we wait before doing a respawn wave of items? ( seconds )
wOS.ItemSpawnFrequency = 0.1

--How much of the lootspawns should be active? ( 0 to 1 )
wOS.LootSpawnPercent = 1

--How long should it take before the items despawn? ( seconds )
wOS.ItemDespawnTime = 600

wOS.SaberExperienceTable = {}

wOS.SaberExperienceTable[ "Default" ] = {
		PlayerKill = 20,
		NPCKill = 5,
}

wOS.SaberExperienceTable[ "vip" ] = {
		PlayerKill = 40,
		NPCKill = 10,
}

wOS.SaberExperienceTable[ "superadmin" ] = {
		PlayerKill = 60,
		NPCKill = 15,
}



