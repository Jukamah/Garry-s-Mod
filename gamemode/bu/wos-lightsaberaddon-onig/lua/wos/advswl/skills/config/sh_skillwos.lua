
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

--How much experience is required for the first level?
--This is an assumption based on my default quadratic increase, but it may have no purpose to you.
wOS.MinimumExperience = 200

--Create your own leveling formula with this. The default property is a quadratic increase
--( level^2 )*wOS.MinimumExperience*0.5 + level*wOS.MinimumExperience + wOS.MinimumExperience
--This amounts to the ( ax^2 + bx + c ) format of increase
--You can use this to create set amounts per level by returning a table
--If you need help setting this up you'll probably want to ask, but it's just simple math so there's probably tutorials everywhere
wOS.XPScaleFormula = function( level )
	local required_experience = ( level^2 )*wOS.MinimumExperience*0.5 + level*wOS.MinimumExperience + wOS.MinimumExperience
	return required_experience
end 

--What is the max level for the Skill Leveling? Set this to FALSE if you want it to go infinitely
wOS.SkillMaxLevel = false

--Should we be able to see the Combat Level and XP on the HUD?
wOS.MountLevelToHUD = true

--Should we be able to see the combat level of other players above their head?
wOS.MountLevelToPlayer = true