
--[[-------------------------------------------------------------------
	Lightsaber Console Commands:
		Changing forms, stances, force powers, maybe more?
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

concommand.Add( "wos_openinventory", function( ply, cmd, args )

	net.Start( "wOS.Crafting.ViewInventory" )
		net.WriteTable( ply.SaberInventory )
		net.WriteTable( ply.RawMaterials )
	net.Send( ply )
	
end )

concommand.Add( "wos_spawnitem", function( ply, cmd, args )
	
	if not ply:Alive() then return end
	if not ply:IsSuperAdmin() then return end
	local item = tonumber( args[1] )
	local itemdata = wOS:GetItemData( item )
	if not itemdata then return end
	
	local pos = ply:EyePos() + ply:GetForward()*30
	
	wOS:CreateSaberItem( pos, itemdata.Name )
	print( "[wOS] Player " .. ply:Nick() .. " spawned item " .. itemdata.Name )
	
end )

concommand.Add( "wos_listitems", function( ply, cmd, args )
	
	if not ply:IsSuperAdmin() then return end
	ply:PrintMessage( HUD_PRINTCONSOLE, "------------------------------------------------------" )
	ply:PrintMessage( HUD_PRINTCONSOLE, "---------Advanced Lightsaber Combat Item List---------" )
	ply:PrintMessage( HUD_PRINTCONSOLE, "------------------------------------------------------" )
	for id, item in pairs( wOS.ItemIDTranslations ) do
		ply:PrintMessage( HUD_PRINTCONSOLE, id .. "			=			" .. item )
	end
	ply:PrintMessage( HUD_PRINTCONSOLE, "------------------------------------------------------" )
	ply:PrintMessage( HUD_PRINTCONSOLE, "------------------------------------------------------" )	
	
end )

concommand.Add( "wos_lootspawn_start", function( ply, cmd, args )
	if not ply:IsSuperAdmin() then return end
	ply:Give( "wos_poolitemplacer" )
end )

concommand.Add( "wos_lootspawn_end", function( ply, cmd, args )
	if not ply:IsSuperAdmin() then return end
	if ply:HasWeapon( "wos_poolitemplacer" ) then ply:StripWeapon( "wos_poolitemplacer" ) end
	wOS:SaveItemSpawns()
end )