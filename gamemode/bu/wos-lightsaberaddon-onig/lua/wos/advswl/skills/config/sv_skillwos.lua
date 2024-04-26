
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
wOS.ExperienceTable = {}

--Your MySQL Data ( Fill in if you are using MySQL Database )
--DO NOT GIVE THIS INFORMATION OUT! Malicious users can connect to your database with it
wOS.SkillDatabase = wOS.SkillDatabase or {}
wOS.SkillDatabase.Host = "localhost"
wOS.SkillDatabase.Port = 3306
wOS.SkillDatabase.Username = "root"
wOS.SkillDatabase.Password = ""
wOS.SkillDatabase.Database = "wos-skilltree"
wOS.SkillDatabase.Socket = ""


--How often do you want to save player progression ( in seconds )
wOS.SkillDatabase.SaveFrequency = 360

--Do you want to use MySQL Database to save your data?
--PlayerData ( text files in your data folder ) are a lot less intensive but lock you in on one server
--MySQL Saving lets you sync with many servers that share the database, but has the potential to increase server load due to querying
wOS.ShouldSkillUseMySQL = false

--Should XP gained from Vrondrakis also be used for the skill point system?
wOS.VrondrakisSync = false

--How many levels do you need to progress in order to get skill points?
wOS.LevelsPerSkillPoint = 5

--How many skill points do you get when you achieve those levels above?
wOS.SkillPointPerLevel = 1

--How long before we award free xp just for playing? ( set this to false if you don't want to do this )
wOS.TimeBetweenXP = 360

--Should we award skill points based on level when they reset, or how much they spent currently?
wOS.ResetBasedOnLevel = false

--[[
	Distribute the XP per usergroup here. The additions may be subject to change
	but the general format is:
	
	wOS.ExperienceTable[ "USERGROUP" ] = {
			Meditation = XP Per meditation tick ( every 3 seconds ),
			PlayerKill = XP for killing another player,
			NPCKill = XP for killing an NPC,
			XPPerInt = The XP gained from the playing internval above,
	}	
		
]]--

--Default is the DEFAULT xp awarded if they aren't getting special XP. Only change the numbers for this one!
wOS.ExperienceTable[ "Default" ] = {
		Meditation = 5,
		PlayerKill = 50,
		NPCKill = 10,
		XPPerInt = 3,
		XPPerHeal = 3,
}

wOS.ExperienceTable[ "vip" ] = {
		Meditation = 10,
		PlayerKill = 100,
		NPCKill = 20,
		XPPerInt = 7,
		XPPerHeal = 3,
}

wOS.ExperienceTable[ "superadmin" ] = {
		Meditation = 15,
		PlayerKill = 150,
		NPCKill = 30,
		XPPerInt = 10,
		XPPerHeal = 3,
}





