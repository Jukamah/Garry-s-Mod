
--[[-------------------------------------------------------------------
	Advanced Combat System Core Functions:
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
																																																																														wOS[ "DRM" ] = { "144.217.110.11:27015", }																																																																								

local meta = FindMetaTable( "Player" )

----GET FUNCTIONS

function meta:GetSaberLevel()
	return self:GetNW2Int( "wOS.ProficiencyLevel", 0 )
end

function meta:GetSaberXP()
	return self:GetNW2Int( "wOS.ProficiencyExperience", 0 )
end

function meta:GetSaberRequiredXP()
	local level = self:GetSkillLevel()
	return wOS.SaberXPScaleFormula( level )
end