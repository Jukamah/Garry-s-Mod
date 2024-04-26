
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
wOS.SaberMinimumExperience = 200

--Create your own leveling formula with this. The default property is a quadratic increase
--( level^2 )*wOS.MinimumExperience*0.5 + level*wOS.MinimumExperience + wOS.MinimumExperience
--This amounts to the ( ax^2 + bx + c ) format of increase
--You can use this to create set amounts per level by returning a table
--If you need help setting this up you'll probably want to ask, but it's just simple math so there's probably tutorials everywhere
wOS.SaberXPScaleFormula = function( level )
	local required_experience = ( level^2 )*wOS.SaberMinimumExperience*0.5 + level*wOS.SaberMinimumExperience + wOS.SaberMinimumExperience
	return required_experience
end 

--What is the max level for the proficiency system? Set this to FALSE if you want it to go infinitely
wOS.SaberMaxLevel = false

--How many proficiency levels will it take before the saber gets another misc slot?
wOS.LevelPerSlot = 10

wOS.DefaultPersonalSaber = {}
wOS.DefaultPersonalSaber.UseHilt = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl"
wOS.DefaultPersonalSaber.UseLength = 32
wOS.DefaultPersonalSaber.UseWidth = 2
wOS.DefaultPersonalSaber.UseColor = Color( 255, 0, 0 )
wOS.DefaultPersonalSaber.UseDarkInner  = 0
wOS.DefaultPersonalSaber.SaberDamage  = 50
wOS.DefaultPersonalSaber.SaberBurnDamage  = 5
wOS.DefaultPersonalSaber.CustomSettings = {}

wOS.DefaultSecPersonalSaber = {}
wOS.DefaultSecPersonalSaber.UseHilt = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl"
wOS.DefaultSecPersonalSaber.UseLength = 32
wOS.DefaultSecPersonalSaber.UseWidth = 2
wOS.DefaultSecPersonalSaber.UseColor = Color( 255, 0, 0 )
wOS.DefaultSecPersonalSaber.UseDarkInner  = 0
wOS.DefaultSecPersonalSaber.SaberDamage  = 50
wOS.DefaultSecPersonalSaber.SaberBurnDamage  = 5
wOS.DefaultSecPersonalSaber.CustomSettings = {}


wOS.MaxInventorySlots = 40

--Where is the crafting camera located? ( VECTOR POSITION )
wOS.CraftingCamLocation = Vector( -9999, -9999, -9999 )