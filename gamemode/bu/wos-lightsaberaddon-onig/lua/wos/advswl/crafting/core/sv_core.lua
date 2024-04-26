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
wOS.ItemList = wOS.ItemList or {}
wOS.TransmitableItems = {}
wOS.BlueprintList = wOS.BlueprintList or {}
wOS.RawMaterialList = wOS.RawMaterialList or {}
wOS.ItemIDTranslations = {}

local meta = FindMetaTable( "Player" )

function meta:SetSaberLevel( num )
	self:SetNW2Int( "wOS.ProficiencyLevel", num )
end

function meta:SetSaberXP( num )
	self:SetNW2Int( "wOS.ProficiencyExperience", num )
end

function meta:AddSaberXP( num )
	if wOS.SaberMaxLevel then 
		if self:GetSaberLevel() >= wOS.SaberMaxLevel then 
			return
		end
	end
	self:SetSaberXP( self:GetSaberXP() + num )
	self:CheckProficiencyLevel()	
end

function meta:CheckProficiencyLevel()

	local xp = self:GetSaberXP()
	local level = self:GetSaberLevel()
	local reqxp = wOS.SaberXPScaleFormula( level )
	
	if reqxp <= xp then
		if wOS.SaberMaxLevel then 
			if level >= wOS.SaberMaxLevel then 
				return
			end
		end
		self:SaberLevelUp()
	end
	
end

function meta:SaberLevelUp()
	self:SetSaberLevel( self:GetSaberLevel() + 1 )
	self:SendLua( [[ surface.PlaySound( "buttons/button24.wav" ) ]] )
	self:SendLua( [[ notification.AddLegacy( "[wOS] Congratulations! Your Proficiency Levey is now ]] .. self:GetSaberLevel() .. [[", NOTIFY_GENERIC, 3 ) ]] )
	if self:GetSaberLevel() % wOS.LevelPerSlot == 0 then
		self:SendLua( [[ notification.AddLegacy( "[wOS] You've earned an extension slot! Head to the crafting bench to fill it.", NOTIFY_GENERIC, 3 ) ]] )
	end
	self:CheckSkillLevel()
end


function wOS:RegisterItem( DATA )

	self.ItemList[ DATA.Name ] = DATA
	wOS.ItemIDTranslations[ #wOS.ItemIDTranslations + 1 ] = DATA.Name
	
	local transfer = {}
	transfer.Name = DATA.Name
	transfer.Description = DATA.Description
	transfer.BurnOnUse = DATA.BurnOnUse
	transfer.Type = DATA.Type
	transfer.UserGroups = DATA.UserGroups
	transfer.Model = DATA.Model
	transfer.Ingredients = DATA.Ingredients
	transfer.Result = DATA.Result
	transfer.Rarity = DATA.Rarity
	
	if DATA.Type == WOSTYPE.BLUEPRINT then
		wOS.BlueprintList[ DATA.Name ] = DATA
	end
	
	if DATA.Type == WOSTYPE.RAWMATERIAL then
		wOS.RawMaterialList[ DATA.Name ] = DATA
	end
	
	wOS.TransmitableItems[ DATA.Name ] = table.Copy( transfer )
	print( "[wOS] Successfully registered crafting item: " .. DATA.Name )
	
end

function wOS:GetItemData( item )

	if not item then return end
	
	if isnumber( item ) then
		item = self.ItemIDTranslations[ item ]
		if not item then return end
		return self.ItemList[ item ]
	end

	return self.ItemList[ item ]
	
end

function wOS:CanEquipItem( ply, item ) 
	if not ply or not item then return false end
	if item.UserGroups then
		if !table.HasValue( item.UserGroups, ply:GetUserGroup() ) then return false end
	end
	return true
end

function wOS:TransmitPersonalSaber( caller, ply )
	
	if not ply then ply = caller end
	
	net.Start( "wOS.Crafting.SendPlayerData" )
		net.WriteTable( ply.PersonalSaberItems )
		net.WriteTable( ply.SecPersonalSaberItems )
		net.WriteTable( ply.SaberMiscItems )
		net.WriteBool( ply == caller )
		net.WriteEntity( ply )
	net.Send( caller )
	
end

function wOS:TransmitItems( caller )

	if not caller then return end
	
	local splitnum = 250
	
	local split
	if table.Count( wOS.TransmitableItems ) > splitnum then
		split = true
	end
	
	
	if not split then
		net.Start( "wOS.Crafting.SendItems" )
			net.WriteTable( wOS.TransmitableItems )
		net.Send( caller )
		return
	end
	
	local count = 0
	local xfer = {}
	for k, v in pairs( wOS.TransmitableItems ) do
		xfer[k] = v
		count = count + 1
		if count >= splitnum then
			net.Start( "wOS.Crafting.SendItems" )
				net.WriteTable( xfer )
			net.Send( caller )
			count = 0
			xfer = {}
		end
	end
	
	if count > 0 then
		net.Start( "wOS.Crafting.SendItems" )
			net.WriteTable( xfer )
		net.Send( caller )	
	end
	
end