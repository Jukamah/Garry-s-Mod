
--[[-------------------------------------------------------------------
	Advanced Combat System Core Net Functions:
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
util.AddNetworkString( "wOS.Crafting.SendItems" )
util.AddNetworkString( "wOS.Crafting.SendPlayerData" )
util.AddNetworkString( "wOS.Crafting.RefreshWeapon" )
util.AddNetworkString( "wOS.Crafting.RefreshWeaponDual" )
util.AddNetworkString( "wOS.Crafting.UpdateItems" )
util.AddNetworkString( "wOS.Crafting.PreviewChange" )
util.AddNetworkString( "wOS.Crafting.ViewInventory" )
util.AddNetworkString( "wOS.Crafting.ChangeSlot" )
util.AddNetworkString( "wOS.Crafting.DropItem" )
util.AddNetworkString( "wOS.Crafting.DropMaterial" )
util.AddNetworkString( "wOS.Crafting.UpdateInventory" )
util.AddNetworkString( "wOS.Crafting.OpenCraftingMenu" )
util.AddNetworkString( "wOS.Crafting.UpdateMaterials" )
util.AddNetworkString( "wOS.Crafting.UpdateBlueprints" )
util.AddNetworkString( "wOS.Crafting.CraftBlueprint" )
util.AddNetworkString( "wOS.Crafting.RefreshCraftMenu" )

net.Receive( "wOS.Crafting.PreviewChange", function( len, ply )

	local second_saber = net.ReadBool()
	local itemlist = net.ReadTable()
	local demosaber = table.Copy( wOS.DefaultPersonalSaber )
	if second_saber then
		demosaber = table.Copy( wOS.DefaultSecPersonalSaber )
	end
	for typ, item in pairs( itemlist ) do
		local data = wOS:GetItemData( item )
		if not data then continue end
		if not wOS:CanEquipItem( ply, data ) then continue end
		data.OnEquip( demosaber )
	end
	net.Start( "wOS.Crafting.PreviewChange" )
		net.WriteBool( second_saber )
		net.WriteTable( demosaber )
	net.Send( ply )
	
end )

net.Receive( "wOS.Crafting.ChangeSlot", function( len, ply )

	if ply.InWOSCrafingMenu then return end

	local oldslot = net.ReadInt( 32 )
	local newslot = net.ReadInt( 32 )
	
	local olditem = ply.SaberInventory[ oldslot ]
	local newitem = ply.SaberInventory[ newslot ]

	ply.SaberInventory[ oldslot ] = newitem
	ply.SaberInventory[ newslot ] = olditem
	
end )

net.Receive( "wOS.Crafting.DropMaterial", function( len, ply )

	if ply.InWOSCrafingMenu then return end

	local material = net.ReadString()
	local amount = net.ReadInt( 32 )
	
	if amount < 1 then return end
	
	local matdata = wOS.RawMaterialList[ material ]
	if not matdata then return end
	
	if not ply.RawMaterials[ material ] then return end
	if ply.RawMaterials[ material ] < 1 then return end
	
	if ply.RawMaterials[ material ] < amount then
		amount = ply.RawMaterials[ material ]
	end
	
	local pos = ply:EyePos() + ply:GetForward()*30
	local ent = wOS:CreateMaterialStack( pos, matdata, amount )
	if ent then
		ent:SetOwner( ply )
	end
	ply:SendLua( [[ surface.PlaySound( "items/ammocrate_open.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] You dropped ]] .. amount .. [[ ]] .. material .. [[.", NOTIFY_ERROR, 3 ) ]] )
	
	ply.RawMaterials[ material ] = ply.RawMaterials[ material ] - amount
	net.Start( "wOS.Crafting.UpdateMaterials" )
		net.WriteTable( ply.RawMaterials )
	net.Send( ply )

end )

net.Receive( "wOS.Crafting.DropItem", function( len, ply )

	if ply.InWOSCrafingMenu then return end

	local dropslot = net.ReadInt( 32 )
	local item = ply.SaberInventory[ dropslot ]
	if not item then return end

	local itemdata = wOS:GetItemData( item )
	if not itemdata then return end
	
	local pos = ply:EyePos() + ply:GetForward()*30
	
	local ent = wOS:CreateSaberItem( pos, item )
	if ent then
		ent:SetOwner( ply )
	end
	ply:SendLua( [[ surface.PlaySound( "items/ammocrate_open.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] ]] .. item .. [[ has been removed from your inventory.", NOTIFY_ERROR, 3 ) ]] )
	ply.SaberInventory[ dropslot ] = "Empty"
	
	net.Start( "wOS.Crafting.UpdateInventory" )
		net.WriteTable( ply.SaberInventory )
	net.Send( ply )
	
end )

net.Receive( "wOS.Crafting.CraftBlueprint", function( len, ply )

	local blueprint = net.ReadString()
	local bluedata = wOS.BlueprintList[ blueprint ]
	if not bluedata then return end
	
	local can_craft = false
	for slot, item in pairs( ply.SaberInventory ) do
		if item == blueprint then can_craft = true break end
	end
	if not can_craft then return end
	
	can_craft = true
	for material, amount in pairs( bluedata.Ingredients ) do
		if not ply.RawMaterials[ material ] then can_craft = false break end
		if ply.RawMaterials[ material ] < amount then can_craft = false break end
		ply.RawMaterials[ material ] = ply.RawMaterials[ material ] - amount
	end
	if not can_craft then
		ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
		ply:SendLua( [[ notification.AddLegacy( "[wOS] Insufficient materials to craft blueprint.", NOTIFY_ERROR, 3 ) ]] )
		return
	end
	
	if wOS:HandleItemPickup( ply, bluedata.Result ) then
		bluedata.OnCrafted( ply )
		if bluedata.BurnOnUse then
			local corrected = false
			for slot, name in pairs( ply.SaberInventory ) do
				if name == blueprint then 
					if corrected then break end
					ply.SaberInventory[ slot ] = "Empty"
					corrected = true
				end
			end
		end
	end
	
	net.Start( "wOS.Crafting.RefreshCraftMenu" )
		net.WriteTable( ply.SaberInventory )
	net.Send( ply )
		
end )


net.Receive( "wOS.Crafting.UpdateItems", function( len, ply )

	local itemlist = net.ReadTable()
	local secitemlist = net.ReadTable()
	local miscitems = net.ReadTable()
	local oldinventory = table.Copy( ply.PersonalSaberItems )
	local secoldinventory = table.Copy( ply.SecPersonalSaberItems )
	local oldmisc = table.Copy( ply.SaberMiscItems )
	
	ply.PersonalSaberItems = {}
	ply.SecPersonalSaberItems = {}
	ply.PersonalSaber = {}
	ply.SecPersonalSaber = {}
	ply.SaberMiscItems = {}
	ply.SaberMiscFunctions = {}
	
	for typ, item in ipairs( itemlist ) do
		if item == "Standard" then 
			ply.PersonalSaberItems[ typ ] = item
			continue
		end
		if item == "" then continue end
		
		local itemdata = wOS:GetItemData( item )
		if not itemdata then
			print( "[wOS] ERROR: Player " .. ply:Nick() .. " tried to equip unknown item " .. item )
			continue
		end
		
		if not wOS:CanEquipItem( ply, itemdata ) then continue end
		ply.PersonalSaberItems[ typ ] = item
		ply.PersonalSaber[ item ] = itemdata
		
		if oldinventory[ typ ] == item then continue end
		
		local key = table.KeyFromValue( ply.SaberInventory, item ) 
		if key then ply.SaberInventory[ key ] = "Empty" end
		
	end
	
	for typ, item in ipairs( secitemlist ) do
		if item == "Standard" then 
			ply.SecPersonalSaberItems[ typ ] = item
			continue
		end
		if item == "" then continue end
		
		local itemdata = wOS:GetItemData( item )
		if not itemdata then
			print( "[wOS] ERROR: Player " .. ply:Nick() .. " tried to equip unknown item " .. item )
			continue
		end
		
		if not wOS:CanEquipItem( ply, itemdata ) then continue end
		ply.SecPersonalSaberItems[ typ ] = item
		ply.SecPersonalSaber[ item ] = itemdata
		
		if secoldinventory[ typ ] == item then continue end
		
		local key = table.KeyFromValue( ply.SaberInventory, item ) 
		if key then ply.SaberInventory[ key ] = "Empty" end
	end
	
	for slot, item in pairs( miscitems ) do
		if item == "Empty" or item == "" then continue end
		
		local itemdata = wOS:GetItemData( item )
		if not itemdata then
			print( "[wOS] ERROR: Player " .. ply:Nick() .. " tried to equip unknown item " .. item )
			continue
		end
		
		if not wOS:CanEquipItem( ply, itemdata ) then continue end
		ply.SaberMiscItems[ #ply.SaberMiscItems + 1 ] = item
		ply.SaberMiscFunctions[ item ] = itemdata
		
		local keys = table.KeysFromValue( oldmisc )
		if #keys > 0 then continue end
		
		local key = table.KeyFromValue( ply.SaberInventory, item ) 
		if key then ply.SaberInventory[ key ] = "Empty" end
	end
	
	for typ, item in ipairs( oldinventory ) do
		if item == "Standard" or item == "" then continue end
		if ply.PersonalSaberItems[ typ ] == item then continue end
		local itemdata = wOS:GetItemData( item )
		if not itemdata then continue end
		
		if not itemdata.BurnOnUse then
			wOS:HandleItemPickup( ply, item )
		end
	end
	
	for typ, item in ipairs( secoldinventory ) do
		if item == "Standard" or item == "" then continue end
		if ply.SecPersonalSaberItems[ typ ] == item then continue end
		local itemdata = wOS:GetItemData( item )
		if not itemdata then continue end
		
		if not itemdata.BurnOnUse then
			wOS:HandleItemPickup( ply, item )
		end
	end
	
	for slot, item in pairs( oldmisc ) do
		if item == "Empty" or item == "" then continue end
		local keys = table.KeysFromValue( ply.SaberMiscItems )
		if #keys > 0 then continue end
		local itemdata = wOS:GetItemData( item )
		if not itemdata then continue end
		
		if not itemdata.BurnOnUse then
			wOS:HandleItemPickup( ply, item )
		end
	end
	
	
	if ply:HasWeapon( "weapon_lightsaber_personal" ) then
		ply:StripWeapon( "weapon_lightsaber_personal" )
		ply:Give( "weapon_lightsaber_personal" )
		if ply:HasWeapon( "weapon_lightsaber_personal_dual" ) then
			ply:StripWeapon( "weapon_lightsaber_personal_dual" )
		end
		if ply.CanUseDuals then
			ply:Give( "weapon_lightsaber_personal_dual" )
		end
	end
	
	ply.InWOSCrafingMenu = false
	
end )