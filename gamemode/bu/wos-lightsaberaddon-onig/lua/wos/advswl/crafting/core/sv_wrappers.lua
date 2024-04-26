
--[[-------------------------------------------------------------------
	Lightsaber Registry System:
		Make all those pretty effects actually work properly.
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
wOS.CraftingDatabase = wOS.CraftingDatabase or {}

local DATA

if wOS.ShouldCraftingUseMySQL then
	require('mysqloo')
	DATA = mysqloo.CreateDatabase( wOS.CraftingDatabase.Host, wOS.CraftingDatabase.Username, wOS.CraftingDatabase.Password, wOS.CraftingDatabase.Database, wOS.CraftingDatabase.Port, wOS.CraftingDatabase.Socket )
	if not DATA then
		print( "[wOS] MySQL Database connection failed. Falling back to PlayerData" )
		wOS.ShouldCraftingUseMySQL = false
	else
		print( "[wOS] Crafting Database MySQL connection was successful!" )	
	end
end

local MYSQL_COLUMNS_GENERAL = "( SteamID varchar(255), Level int, Experience bigint )"
local MYSQL_COLUMNS_CRAFTED = "( SteamID varchar(255), PrimaryItems varchar(255), SecondaryItems varchar(255), MiscItems varchar(255) )"
local MYSQL_COLUMNS_INVENTORY = "( SteamID varchar(255), Items varchar(255) )"
local MYSQL_COLUMNS_RAWINVENTORY = "( SteamID varchar(255), Item varchar(255), Amount bigint )"
local MYSQL_COLUMNS_ITEMROSTER = "( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, Item varchar(255), PRIMARY KEY (`ID`) )"

wOS.CraftingDatabase.ItemToID = {}
wOS.CraftingDatabase.IDToItem = {}

function wOS.CraftingDatabase:Initialize()
	
	if DATA then
		local TRANS = DATA:CreateTransaction()
		TRANS:Query( "CREATE TABLE IF NOT EXISTS leveldata " .. MYSQL_COLUMNS_GENERAL )
		TRANS:Query( "CREATE TABLE IF NOT EXISTS saberdata " .. MYSQL_COLUMNS_CRAFTED )
		TRANS:Query( "CREATE TABLE IF NOT EXISTS inventory " .. MYSQL_COLUMNS_INVENTORY )
		TRANS:Query( "CREATE TABLE IF NOT EXISTS rawmaterials " .. MYSQL_COLUMNS_RAWINVENTORY )
		TRANS:Query( "CREATE TABLE IF NOT EXISTS itemroster " .. MYSQL_COLUMNS_ITEMROSTER )
		TRANS:Start(function(transaction, status, err)
			if (!status) then error(err) return end
			local CTRANS = DATA:CreateTransaction()
			for item, data in pairs( wOS.ItemList ) do
				local iteme = DATA:escape( item )
				CTRANS:Query( [[ INSERT INTO itemroster ( Item ) SELECT * FROM (SELECT ']] .. iteme .. [[' ) AS tmp WHERE NOT EXISTS ( SELECT Item FROM itemroster WHERE Item = ']] .. iteme .. [[' ) LIMIT 1 ]] )
			end
			CTRANS:Query( "SELECT * FROM itemroster" )
			CTRANS:Start( function(transaction, status, err)
				if (!status) then error(err) end 
				local queries = transaction:getQueries()
				local itemdata = queries[#queries]:getData()
				if itemdata then
					for _, data in pairs( itemdata ) do
						if not wOS:GetItemData( data.Item ) then continue end
						wOS.CraftingDatabase.ItemToID[ data.Item ] = data.ID
						wOS.CraftingDatabase.IDToItem[ data.ID ] = data.Item
					end
				end
			end )
		end)
	else
		if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
		if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
		if not file.Exists( "wos/advswl/crafting", "DATA" ) then file.CreateDir( "wos/advswl/crafting" ) end
		if not file.Exists( "wos/advswl/crafting/leveling", "DATA" ) then file.CreateDir( "wos/advswl/crafting/leveling" ) end
		if not file.Exists( "wos/advswl/crafting/personal", "DATA" ) then file.CreateDir( "wos/advswl/crafting/personal" ) end
		if not file.Exists( "wos/advswl/crafting/inventory", "DATA" ) then file.CreateDir( "wos/advswl/crafting/inventory" ) end
		if not file.Exists( "wos/advswl/crafting/rawmaterials", "DATA" ) then file.CreateDir( "wos/advswl/crafting/rawmaterials" ) end
	end
	
end

function wOS.CraftingDatabase:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	ply.PersonalSaberItems = {}
	ply.PersonalSaber = {}
	ply.SecPersonalSaberItems = {}
	ply.SecPersonalSaber = {}
	ply.SaberInventory = {}	
	ply.RawMaterials = {}
	ply.SaberMiscItems = {}
	ply.SaberMiscFunctions = {}

	for i=1, 5 do
		ply.PersonalSaberItems[ i ] = "Standard"
		ply.SecPersonalSaberItems[ i ] = "Standard"
	end
	
	if DATA then
		local TRANS = DATA:CreateTransaction()		
		TRANS:Query( "SELECT * FROM leveldata WHERE SteamID = '" .. steam64 .. "'" )
		TRANS:Query( "SELECT * FROM saberdata WHERE SteamID = '" .. steam64 .. "'" )
		TRANS:Query( "SELECT * FROM inventory WHERE SteamID = '" .. steam64 .. "'" )
		TRANS:Query( "SELECT * FROM rawmaterials WHERE SteamID = '" .. steam64 .. "'" )
		TRANS:Start(function(transaction, status, err)
			if (!status) then error(err) end
			local creation_needed = false		
			local queries = transaction:getQueries()
			local C_TRANS = DATA:CreateTransaction()	
			local leveldata = queries[1]:getData()
			if table.Count( leveldata ) < 1 then
				creation_needed = true
				C_TRANS:Query( "INSERT INTO leveldata ( SteamID, Level, Experience ) VALUES ( '" .. steam64 .. "','"  .. 0 .. "','" .. 0 .. "')" )
			else
				leveldata = leveldata[1]
				ply:SetSaberLevel( leveldata.Level )
				ply:SetSaberXP( leveldata.Experience )
			end
			local itemdata = queries[2]:getData()
			if table.Count( itemdata ) < 1 then
				creation_needed = true
				local str = ""
				for i=1, 5 do
					str = str .. "0;"
				end
				C_TRANS:Query( "INSERT INTO saberdata ( SteamID, PrimaryItems, SecondaryItems, MiscItems ) VALUES ( '" .. steam64 .. "','" .. str .. "','" .. str .. "', '')" )
			else
				itemdata = itemdata[1]
				local items = string.Explode( ";", itemdata.PrimaryItems )
				for typ, id in pairs( items ) do
					local item = wOS.CraftingDatabase.IDToItem[ tonumber( id ) ]
					if not item then item = "Standard" end
					local idata = wOS:GetItemData( item )
					if not idata then item = "Standard" end
					ply.PersonalSaberItems[ typ ] = item
					ply.PersonalSaber[ item ] = idata
				end
				items = string.Explode( ";", itemdata.SecondaryItems )
				for typ, id in pairs( items ) do
					local item = wOS.CraftingDatabase.IDToItem[ tonumber( id ) ]
					if not item then item = "Standard" end
					local idata = wOS:GetItemData( item )
					if not idata then item = "Standard" end
					ply.SecPersonalSaberItems[ typ ] = item
					ply.SecPersonalSaber[ item ] = idata
				end
				items = string.Explode( ";", itemdata.MiscItems )
				for typ, id in pairs( items ) do
					local item = wOS.CraftingDatabase.IDToItem[ tonumber( id ) ]
					if not item then continue end
					local idata = wOS:GetItemData( item )
					if not idata then continue end
					ply.SaberMiscItems[ item ] = item
					ply.SaberMiscFunctions[ item ] = idata
				end
			end
			local invdata = queries[3]:getData()
			if table.Count( invdata ) < 1 then
				creation_needed = true
				local fill = ""
				for i=1, wOS.MaxInventorySlots do
					ply.SaberInventory[ i ] = "Empty"
					fill = fill .. "0;"
				end
				C_TRANS:Query( "INSERT INTO inventory ( SteamID, Items ) VALUES ( '" .. steam64 .. "','" .. fill .. "')" )	
			else
				invdata = invdata[1]
				local items = string.Explode( ";", invdata.Items )
				for slot, item in pairs( items ) do
					local name = wOS.CraftingDatabase.IDToItem[ tonumber( item ) ]
					if not name then name = "Empty" end
					ply.SaberInventory[ slot ] = name
				end
			end
			for material, _ in pairs( wOS.RawMaterialList ) do
				ply.RawMaterials[ material ] = 0
			end
			
			local rawdata = queries[4]:getData()
			if table.Count( rawdata ) > 0 then
				for slot, data in pairs( rawdata ) do
					if not wOS.RawMaterialList[ data.Item ] then continue end
					ply.RawMaterials[ data.Item ] = data.Amount
				end
			end
			
			if creation_needed then
				C_TRANS:Start(function(transaction, status, err) end)
			end
		
			wOS:TransmitPersonalSaber( ply )
		end )
		
	else
	
		local read = file.Read( "wos/advswl/crafting/leveling/" .. steam64 .. ".txt", "DATA" )	
		if not read then			
			local data = { Level = 0, Experience = 0 }
			data = util.TableToJSON( data )
			file.Write( "wos/advswl/crafting/leveling/" .. steam64 .. ".txt", data )	
		else
			local readdata = util.JSONToTable( read )
			ply:SetSaberLevel( readdata.Level )
			ply:SetSaberXP( readdata.Experience )
		end
		read = file.Read( "wos/advswl/crafting/personal/" .. steam64 .. ".txt", "DATA" )	
		if not read then 
			local data = { Primary = {}, Secondary = {}, MiscItems = {} }
			for i=1, 5 do
				data.Primary[ i ] = "Standard"
				data.Secondary[ i ] = "Standard"
			end
			data = util.TableToJSON( data )
			file.Write( "wos/advswl/crafting/personal/" .. steam64 .. ".txt", data )
		else
			local items = util.JSONToTable( read )
			for typ, item in pairs( items.Primary ) do
				local idata = wOS:GetItemData( item )
				if not idata then item = "Standard" end
				ply.PersonalSaberItems[ typ ] = item
				ply.PersonalSaber[ item ] = idata
			end
			for typ, item in pairs( items.Secondary ) do
				local idata = wOS:GetItemData( item )
				if not idata then item = "Standard" end
				ply.SecPersonalSaberItems[ typ ] = item
				ply.SecPersonalSaber[ item ] = idata
			end
			for typ, item in pairs( items.MiscItems ) do
				local idata = wOS:GetItemData( item )
				if not idata then continue end
				ply.SaberMiscItems[ typ ] = item
				ply.SaberMiscFunctions[ item ] = idata			
			end
		end
		
		read = file.Read( "wos/advswl/crafting/inventory/" .. steam64 .. ".txt", "DATA" )	
		if not read then 
			local data = {}
			for i=1, wOS.MaxInventorySlots do
				data[ i ] = "Empty"
			end			
			ply.SaberInventory = table.Copy( data )
			data = util.TableToJSON( data )
			file.Write( "wos/advswl/crafting/inventory/" .. steam64 .. ".txt", data )
		else
			local items = util.JSONToTable( read )
			for slot, item in pairs( items ) do
				ply.SaberInventory[ slot ] = item
			end
			if #ply.SaberInventory < wOS.MaxInventorySlots then
				for i=#ply.SaberInventory, wOS.MaxInventorySlots do
					ply.SaberInventory[ i ] = "Empty"
				end			
			end
		end
		
		read = file.Read( "wos/advswl/crafting/rawmaterials/" .. steam64 .. ".txt", "DATA" )	
		for material, _ in pairs( wOS.RawMaterialList ) do
			ply.RawMaterials[ material ] = 0
		end
		if read then
			local raw = util.JSONToTable( read )
			for item, number in pairs( raw ) do
				if not wOS.RawMaterialList[ item ] then continue end
				ply.RawMaterials[ item ] = number
			end
		end

		wOS:TransmitPersonalSaber( ply )
		
	end
	
	wOS:TransmitItems( ply )
	
end

function wOS.CraftingDatabase:SaveData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	if not ply.PersonalSaber then return end
	if not ply.PersonalSaberItems then return end
	if not ply.SaberInventory then return end
	if not ply.RawMaterials then return end
	if not ply.SaberMiscItems then return end
	
	if DATA then
	
		local builddata = ""
		local builddata2 = ""
		local builddata3 = ""
		for i=1, 5 do
            local item = ply.PersonalSaberItems[i]
            local id = wOS.CraftingDatabase.ItemToID[ item ]
            if not id then id = "0" end
            builddata = builddata .. id .. ";"
        end
        
        for i=1, 5 do
            local item = ply.SecPersonalSaberItems[i]
            local id = wOS.CraftingDatabase.ItemToID[ item ]
            if not id then id = "0" end
            builddata2 = builddata2 .. id .. ";"
        end
		
		for typ, item in pairs( ply.SaberMiscItems ) do
			local id = wOS.CraftingDatabase.ItemToID[ item ]
			if not id then continue end
			builddata3 = builddata3 .. id .. ";"
		end
		
		local invdata = ""
		for slot = 1, wOS.MaxInventorySlots do
			local item = ply.SaberInventory[ slot ]
			if not item then 
				item = "Empty"
			end
			local name = wOS.CraftingDatabase.ItemToID[ item ]
			if not name then 
				name = "0" 
				ply.SaberInventory[ slot ] = "Empty"
			end
			invdata = invdata .. name .. ";"
		end

		local TRANS = DATA:CreateTransaction()		
		TRANS:Query( "UPDATE leveldata SET Level = " .. ply:GetSaberLevel() .. ", Experience = " .. ply:GetSaberXP() .. " WHERE SteamID = " .. steam64 )
		TRANS:Query( "UPDATE saberdata SET PrimaryItems = '" .. DATA:escape( builddata ) .. "', SecondaryItems = '" .. DATA:escape( builddata2 ) .. "', MiscItems = '" .. DATA:escape( builddata3 ) .. "' WHERE SteamID = " .. steam64 )
		TRANS:Query( "UPDATE inventory SET Items = '" .. invdata .. "' WHERE SteamID = " .. steam64 )
		for material, amount in pairs( ply.RawMaterials ) do
			local iteme = DATA:escape( material )
			TRANS:Query( [[ INSERT INTO rawmaterials (SteamID, Item, Amount) VALUES( ']] .. steam64 .. [[', ']] .. iteme .. [[', ]] .. amount .. [[ ) ON DUPLICATE KEY UPDATE Amount=]] .. amount )
		end			
		TRANS:Start(function(transaction, status, err)
			if (!status) then error(err) end
		end)
		
	else
		
		local data = {}
		data.Level = ply:GetSaberLevel()
		data.Experience = ply:GetSaberXP()
		
		data = util.TableToJSON( data )
		file.Write( "wos/advswl/crafting/leveling/" .. steam64 .. ".txt", data )	
		
		local savedata = {}
		savedata.Primary = table.Copy( ply.PersonalSaberItems )
		savedata.Secondary = table.Copy( ply.SecPersonalSaberItems )
		savedata.MiscItems = table.Copy( ply.SaberMiscItems )
		savedata = util.TableToJSON( savedata )
		file.Write( "wos/advswl/crafting/personal/" .. steam64 .. ".txt", savedata )		
		
		local invdata = table.Copy( ply.SaberInventory )
		invdata = util.TableToJSON( invdata )
		file.Write( "wos/advswl/crafting/inventory/" .. steam64 .. ".txt", invdata )		
		
		local rawmats = table.Copy( ply.RawMaterials )
		rawmats = util.TableToJSON( rawmats )
		file.Write( "wos/advswl/crafting/rawmaterials/" .. steam64 .. ".txt", rawmats )			
		
	end

end


hook.Add( "PlayerInitialSpawn", "wOS.Crafting.ItemLoading", function( ply )
	wOS.CraftingDatabase:LoadData( ply )
end )

hook.Add( "PlayerDisconnected", "wOS.Crafting.ItemSaving", function( ply )
	wOS.CraftingDatabase:SaveData( ply )
end )

timer.Create( "wOS.Crafting.AutoSave", wOS.CraftingDatabase.SaveFrequency, 0, function() 
	for _, ply in pairs ( player.GetAll() ) do
		wOS.CraftingDatabase:SaveData( ply )
	end
end )

wOS.CraftingDatabase:Initialize()