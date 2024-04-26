
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
wOS.Lightsaber = wOS.Lightsaber or {}

--This order may look completely stupid, and you'd ask why I wouldn't just cluster them all together
--Well, load orders are very important, and this is the best way to control it

local string = string
local file = file

if SERVER then

	AddCSLuaFile( "wos/advswl/config/sh_serverwos.lua" )
	AddCSLuaFile( "wos/advswl/config/sh_swlwos.lua" )
	AddCSLuaFile( "wos/advswl/config/sh_hiltwos.lua" )
	AddCSLuaFile( "wos/advswl/config/sh_stamina.lua" )
	
	AddCSLuaFile( "wos/advswl/robot-boy/cl_rb655_lightsaber.lua" )	
	AddCSLuaFile( "wos/advswl/robot-boy/sh_rb655_lightsaber_presets.lua" )	
	
	AddCSLuaFile( "wos/advswl/core/cl_core.lua" )
	AddCSLuaFile( "wos/advswl/core/cl_net.lua" )
	AddCSLuaFile( "wos/advswl/core/sh_core.lua" )
	AddCSLuaFile( "wos/advswl/core/sh_hilt_extension.lua" )
	
	AddCSLuaFile( "wos/advswl/anim/sh_forcesequence.lua" )
	AddCSLuaFile( "wos/advswl/anim/cl_forcesequence.lua" )
	
	AddCSLuaFile( "wos/advswl/combat/cl_dualsaber.lua" )	
	AddCSLuaFile( "wos/advswl/combat/cl_saberbase_hook.lua" )		
	
	AddCSLuaFile( "wos/advswl/forcesys/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/forcesys/cl_net.lua" )
	
	AddCSLuaFile( "wos/advswl/devsys/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/devsys/cl_net.lua" )
	
	AddCSLuaFile( "wos/advswl/crafting/loader/loader.lua" )	
	
	AddCSLuaFile( "wos/advswl/formsys/cl_forms.lua" )	
	
	AddCSLuaFile( "wos/advswl/skills/loader/loader.lua" )	
	
	AddCSLuaFile( "wos/advswl/adminmenu/cl_core.lua" )	
	
end

include( "wos/advswl/config/sh_serverwos.lua" )
include( "wos/advswl/config/sh_swlwos.lua" )
include( "wos/advswl/config/sh_hiltwos.lua" )
include( "wos/advswl/config/sh_stamina.lua" )

include( "wos/advswl/robot-boy/sh_rb655_lightsaber_presets.lua" )	
include( "wos/advswl/core/sh_core.lua" )
include( "wos/advswl/core/sh_hilt_extension.lua" )
include( "wos/advswl/anim/sh_forcesequence.lua" )

if SERVER then

	include( "wos/advswl/robot-boy/sv_rb655_lightsaber.lua" )	
	
	include( "wos/advswl/core/sv_resources.lua" )		
	include( "wos/advswl/core/sv_concommands.lua" )	
	include( "wos/advswl/core/sv_core.lua" )
	include( "wos/advswl/core/sv_net.lua" )
	include( "wos/advswl/core/sv_saber_registry.lua" )
	
	include( "wos/advswl/anim/sh_forcesequence.lua" )
	include( "wos/advswl/anim/sv_forcesequence.lua" )
	
	include( "wos/advswl/combat/sv_saberbase_hook.lua" )		
	include( "wos/advswl/combat/sv_combat_hook.lua" )	
			
	include( "wos/advswl/forcesys/sv_core.lua" )		
	include( "wos/advswl/forcesys/sv_net.lua" )	
	
	include( "wos/advswl/devsys/sv_core.lua" )		
	include( "wos/advswl/devsys/sv_net.lua" )		
	
	include( "wos/advswl/formsys/sv_forms.lua" )		
	include( "wos/advswl/formsys/sv_form_register.lua" )
	
	include( "wos/advswl/config/sv_adminsettings.lua" )	
	include( "wos/advswl/adminmenu/sv_net.lua" )	
	
else

	include( "wos/advswl/robot-boy/cl_rb655_lightsaber.lua" )	
	
	include( "wos/advswl/core/cl_core.lua" )
	include( "wos/advswl/core/cl_net.lua" )
	
	include( "wos/advswl/anim/cl_forcesequence.lua" )
	
	include( "wos/advswl/combat/cl_dualsaber.lua" )	
	include( "wos/advswl/combat/cl_saberbase_hook.lua" )		
	
	include( "wos/advswl/forcesys/cl_core.lua" )	
	include( "wos/advswl/forcesys/cl_net.lua" )
	
	include( "wos/advswl/devsys/cl_core.lua" )	
	include( "wos/advswl/devsys/cl_net.lua" )
	
	include( "wos/advswl/formsys/cl_forms.lua" )	
	
	include( "wos/advswl/adminmenu/cl_core.lua" )	 
	
end

include( "wos/advswl/skills/loader/loader.lua" )	
include( "wos/advswl/crafting/loader/loader.lua" )	

	
for _,source in pairs( file.Find( "wos/advswl/addon-loader/*", "LUA"), true ) do
	local lua = "wos/advswl/addon-loader/" .. source
	if SERVER then
		AddCSLuaFile( lua )
	end
	include( lua )
end
