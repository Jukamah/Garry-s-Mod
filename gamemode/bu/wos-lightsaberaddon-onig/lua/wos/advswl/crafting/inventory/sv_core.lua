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

function wOS:CreateSaberItem( pos, name, despawn )
	local item = self:GetItemData( name )
	if not item then return end
	local base = ents.Create( "wos_item_base" )
	base:SetPos( pos )
	base:SetModel( item.Model )
	base:SetItemType( item.Type )
	base:SetItemName( item.Name )
	base:SetItemDescription( item.Description )
	
	if item.Skin then
		base:SetSkin( item.Skin )
	end
	
	if item.Material then
		base:SetMaterial( item.Material )
	end
	base:SetAmount( 1 )
	base:Spawn()
	if despawn then
		base.DespawnTime = CurTime() + self.ItemDespawnTime
	else
		base.DespawnTime = CurTime() + 3*self.ItemDespawnTime	
		base.IsPlayerItem = true
	end
	
	return base
	
end

function wOS:CreateMaterialStack( pos, item, amount )
	local base = ents.Create( "wos_item_base" )
	base:SetPos( pos )
	base:SetModel( item.Model )
	base:SetItemType( WOSTYPE.RAWMATERIAL )
	base:SetItemName( item.Name )
	base:SetItemDescription( item.Description )
	base:SetAmount( amount )	
	if item.Skin then
		base:SetSkin( item.Skin )
	end
	if item.Material then
		base:SetMaterial( item.Material )
	end
	base.DespawnTime = CurTime() + 3*self.ItemDespawnTime	
	base.IsPlayerItem = true
	base:Spawn()
	
	return base
	
end

function wOS:HandleMaterialPickup( ply, name, amount )
	local material = self.RawMaterialList[ name ]
	if not material then 
		ply:ChatPrint( "[wOS] The material you are trying to pick up is invalid. Please contact the server owner!" )
		return false 
	end
	
	if not ply.RawMaterials[ name ] then ply.RawMaterials[ name ] = 0 end
	ply.RawMaterials[ name ] = ply.RawMaterials[ name ] + amount
	
	ply:SendLua( [[ surface.PlaySound( "wos/crafting/item_pickup.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] You picked up ]] .. amount .. [[ ]] .. name .. [[.", NOTIFY_GENERIC, 3 ) ]] )
	
	return true
	
end

function wOS:HandleItemPickup( ply, name )
	local item = self:GetItemData( name )
	if not item then 
		ply:ChatPrint( "[wOS] The item you are trying to pick up is invalid. Please contact the server owner!" )
		return false 
	end
	
	for i = 1, self.MaxInventorySlots do
		if ply.SaberInventory[ i ] == "Empty" then
			ply.SaberInventory[ i ] = name
			ply:SendLua( [[ surface.PlaySound( "wos/crafting/item_pickup.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] ]] .. name .. [[ has been added to your inventory.", NOTIFY_GENERIC, 3 ) ]] )
			return true
		end
	end
	
	ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] You do not have enough inventory space!", NOTIFY_ERROR, 3 ) ]] )
	
	return false 
	
end

function wOS:GiveSaberItem( ply, name )
	if wOS:HandleItemPickup( ply, name ) then 
		wOS:HandleItemPickup( ply, name )
	else
		print( "[wOS] Failed to manually give Player " .. ply:Nick() .. " item " .. name )
	end
end

function wOS:PopulateItemSpawns()
	local validspawns = {}
	local totalspawn = ents.FindByClass( "info_wos_itemspawn" )
	for _, spawn in pairs( totalspawn ) do
		if !spawn:GetOccupied() then
			table.insert( validspawns, spawn )
		end
	end
	if #validspawns < 1 then return end
	
	local items = #ents.FindByClass( "wos_item_base" )
	for _,item in pairs( ents.FindByClass( "wos_item_base" ) ) do
		if item.IsPlayerItem then
			items = items -1
		end
	end
	
	local ratio = items/#totalspawn
	while ratio < wOS.LootSpawnPercent do
		if #validspawns < 1 then return end	
		local lootspawn = table.Random( validspawns )
		local item = table.Random( wOS.ItemList )
		local rnd = math.min( math.random( 0, 50 ) + math.random( 0, 30 ) + math.random( 0, 15 ) + math.random( 0, 5 ) + math.random( 0, 15 ), 100 )
		items = items + 1
		ratio = items/#totalspawn
		if item.Rarity then
			if item.Rarity <= 0 then continue end
			if item.Rarity < rnd then continue end
		end
		
		if lootspawn.SpawnCategories then
			if !lootspawn.SpawnCategories[ item.Type ] then continue end
		end
		
		wOS:CreateSaberItem( lootspawn:GetPos() + Vector( 0, 0, 1 ), item.Name, true )
		table.RemoveByValue( validspawns, lootspawn )
	end
	
end

function wOS:ForceItemSpawns()
	local validspawns = {}
	local totalspawn = ents.FindByClass( "info_wos_itemspawn" )
	for _, spawn in pairs( totalspawn ) do
		if !spawn:GetOccupied() then
			table.insert( validspawns, spawn )
		end
	end
	if #validspawns < 1 then return end
	for _, item in pairs( wOS.ItemList ) do
		if #validspawns < 1 then return end	
		local lootspawn = table.Random( validspawns )
		print( item.Model )
		wOS:CreateSaberItem( lootspawn:GetPos() + Vector( 0, 0, 1 ), item.Name, true )
	end
	
end

function wOS:LoadItemSpawns()
	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/crafting", "DATA" ) then file.CreateDir( "wos/advswl/crafting" ) end
	if not file.Exists( "wos/advswl/crafting/mapdata", "DATA" ) then file.CreateDir( "wos/advswl/crafting/mapdata" ) end

	local read = file.Read( "wos/advswl/crafting/mapdata/" .. string.lower( game.GetMap() ) .. "_json.txt", "DATA" ) 
	if not read then
		MsgN( "[wOS] Error! No Loot Spawn data found for this map!" )
		return
	end
	
	local config = util.JSONToTable( read )
	if not config then
		MsgN( "[wOS] Error! Loot Spawn data for this map is empty!" )
		return	
	end
	
	for k,v in pairs( config ) do
		if v[1] then
			for c,d in pairs( v ) do
				if not istable( d ) then continue end
				local ent = ents.Create( k )
				ent:SetPos( d[1] )
				ent:Spawn()
				ent.AdminPlaced = true
				ent.SpawnCategories = d[2]
			end
		end
	end	
	
end

hook.Add( "InitPostEntity", "wOS.Crafting.LoadItems", wOS.LoadItemSpawns )

function wOS:SaveItemSpawns()

	MsgN( "[wOS] Saving ADVSWL Loot Spawn data..." )

	local enttbl = {
		info_wos_itemspawn = {},
	}
	
	for k,v in pairs( enttbl ) do
	
		for c,d in pairs( ents.FindByClass( k ) ) do
		
			if d.AdminPlaced then
		
				table.insert( enttbl[k], { d:GetPos(), d.SpawnCategories } )
				
			end
		
		end
		
	end
	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/crafting", "DATA" ) then file.CreateDir( "wos/advswl/crafting" ) end
	if not file.Exists( "wos/advswl/crafting/mapdata", "DATA" ) then file.CreateDir( "wos/advswl/crafting/mapdata" ) end

	file.Write( "wos/advswl/crafting/mapdata/" .. string.lower( game.GetMap() ) .. "_json.txt", util.TableToJSON( enttbl ) )

end

timer.Create( "wOS.Crafting.LootSpawn", wOS.ItemSpawnFrequency, 0, wOS.PopulateItemSpawns )

hook.Add( "PostCleanupMap", "wOS.Crafting.ReLoadItems", wOS.LoadItemSpawns )