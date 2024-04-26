
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

--Should the player move in the direction of the animation when attacking?
--VERY VERY ( VERY )IMPORTANT NOTE: I highly recommend you disable this if your tick rate is BELOW 33. YOU WILL SEE STUTTERING OTHERWISE
wOS.EnableLunge = false

--Enable this to only draw lightsaber traces when you are swinging
--This adds a huge buff to performance but will remove the ability to make scorch marks/damage traces when idle/running
wOS.MinimalLightsabers = false

--Determines whether or not the list in the toolgun's menu shouldn't be constructed based on the hilt restrictions
--Enable this if you do not distribute tool guns, as it will just show all hilts available.
wOS.LegacyToolgun = true

--Should we stop non-admins from changing their saber settings through the rb556 console commands?
--This will not affect forced Lightsaber properties. 
--This is useful for BASIC crafting benches that do not utilize the forced properties
--or restricted hilts in the tool gun ( sh_hiltwos.lua settings )
wOS.RestrictConcommands = false

--Enable this if you want to remove the hot key system entirely and use a "Force Select" menu similar to the Form Select menu
--Enabling this will allow players to have more than 9 force abilities equipped to a saber, but remove the hotkey system
wOS.ForceSelectMenu = true

--Enabling this will stop the force icons from rendering.
--Useful for servers with 3D2D HUDs, as it will save clients some frames.
--This will also remove the little icon in the Force Select menu. 
wOS.DisableForceIcons = false

--The frequency ( in seconds ) that the wiltOS Advanced Saber Combat advertisement will print in chat.
--To disable advertisements, just set this to false
--I won't get angry if you disable it, promise
wOS.AdvertTime = false

--This is used to enable the realistic camera on first person lightsabers. 
--Players will be locked into their model's eyes and the camera will be limited by their head movements
--Good for RP purposes, but hard aim and use force abiltiies with
wOS.AlwaysFirstPerson = false

--If your server is using Zhrom's Starwars Prop Pack, this will automatically mount them to the toolgun/crafting benches
--YOU AND YOUR SERVER WILL NEED THIS ADDON!
-- http://steamcommunity.com/sharedfiles/filedetails/?id=740395760&searchtext=Zhrom
wOS.EnableZhromExtension = false

--If your server is using the CloneWars Adventure pack, this will automatically mount them to the toolgun/crafting benches
--YOU AND YOUR SERVER WILL NEED THE CLONE WAR PACK!
wOS.EnableCloneAdventures = false