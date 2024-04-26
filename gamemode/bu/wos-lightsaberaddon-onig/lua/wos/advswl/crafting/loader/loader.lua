
--[[-------------------------------------------------------------------
	Advanced Lightsaber Combat Loader:
		Loads all the files and such
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

--This order may look completely stupid, and you'd ask why I wouldn't just cluster them all together
--Well, load orders are very important, and this is the best way to control it

if SERVER then

	AddCSLuaFile( "wos/advswl/crafting/wyozi/tdui.lua" )	
	AddCSLuaFile( "wos/advswl/crafting/config/sh_craftwos.lua" )	
	AddCSLuaFile( "wos/advswl/crafting/core/sh_core.lua" )
	AddCSLuaFile( "wos/advswl/crafting/core/sh_enums.lua" )
	AddCSLuaFile( "wos/advswl/crafting/core/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/crafting/core/cl_net.lua" )
	AddCSLuaFile( "wos/advswl/crafting/inventory/cl_core.lua" )
	AddCSLuaFile( "wos/advswl/crafting/inventory/sh_core.lua" )	
	
end

include( "wos/advswl/crafting/config/sh_craftwos.lua" )
include( "wos/advswl/crafting/core/sh_enums.lua" )
include( "wos/advswl/crafting/inventory/sh_core.lua" )


if SERVER then
	
	include( "wos/advswl/crafting/config/sv_craftwos.lua" )
	include( "wos/advswl/crafting/core/sv_core.lua" )
	include( "wos/advswl/crafting/core/sh_core.lua" )
	include( "wos/advswl/crafting/core/sv_item_register.lua" )
	include( "wos/advswl/crafting/core/sv_wrappers.lua" )
	include( "wos/advswl/crafting/core/sv_net.lua" )
	include( "wos/advswl/crafting/core/sv_concommands.lua" )
	include( "wos/advswl/crafting/inventory/sv_core.lua" )

	
else
	include( "wos/advswl/crafting/wyozi/tdui.lua" )	
	include( "wos/advswl/crafting/core/sh_core.lua" )	
	include( "wos/advswl/crafting/core/cl_core.lua" )
	include( "wos/advswl/crafting/core/cl_net.lua" )
	include( "wos/advswl/crafting/inventory/cl_core.lua" )
	
end