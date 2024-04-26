--[[-------------------------------------------------------------------
	Skill Tree Register:
		A simple register to keep track of all custom made Skill Trees
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
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.SkillTrees = wOS.SkillTrees or {}

local string = string
local file = file

local function _AddCSLuaFile( lua )

	if SERVER then
		AddCSLuaFile( lua )
	end
	
end

local function _include( load_type, lua )

	if load_type then
		include( lua )
	end
	
end

function wOS.SkillDatabase:Autoloader()

	_include( SERVER, "wos/advswl/skills/mysqloo/sv_mysqloo_funcs.lua" )
	
	for _,source in pairs( file.Find( "wos/advswl/skills/trees/*", "LUA"), true ) do
		local lua = "wos/advswl/skills/trees/" .. source
		_include( SERVER, lua )
	end
	
end

wOS.SkillDatabase:Autoloader()