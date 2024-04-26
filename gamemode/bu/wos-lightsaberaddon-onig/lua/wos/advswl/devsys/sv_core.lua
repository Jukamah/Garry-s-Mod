
--[[-------------------------------------------------------------------
	Lightsaber Force Power Server Core:
		The things we need to make sure the forcepowers actually work.
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

wOS = wOS or {}
wOS.Devestators = wOS.Devestators or {}
wOS.AvailableDevestators = wOS.AvailableDevestators or {}

local string = string
local file = file

local SortedDevestators = {}

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

function wOS.Devestators:RegisterNewPower( data )
	wOS.AvailableDevestators[ data.name ] = data
	SortedDevestators[ data.name ] = table.Copy( data )
	SortedDevestators[ data.name ].action = nil
	SortedDevestators[ data.name ].think = nil
	print( "[wOS] Successfully added devestator: " .. data.name )
end

hook.Add( "PlayerInitialSpawn", "wOS.Lightsabers.SendAllDevestators", function( ply )
	net.Start( "wOS.Lightsabers.SendDevestatorData" )
		net.WriteTable( SortedDevestators )
	net.Send( ply )
end )

function wOS.Devestators:Autoloader()

	for _,source in pairs( file.Find( "wos/advswl/devestators/*", "LUA"), true ) do
		local lua = "wos/advswl/devestators/" .. source
		_include( SERVER, lua )
	end
	
end

wOS.Devestators:Autoloader()