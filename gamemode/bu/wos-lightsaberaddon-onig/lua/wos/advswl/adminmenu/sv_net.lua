
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
util.AddNetworkString( "wOS.SkillTree.AddXP" )
util.AddNetworkString( "wOS.SkillTree.AddLevel" )
util.AddNetworkString( "wOS.SkillTree.AddSkillPoints" )
util.AddNetworkString( "wOS.SkillTree.SetXP" )
util.AddNetworkString( "wOS.SkillTree.SetLevel" )
util.AddNetworkString( "wOS.SkillTree.SetSkillPoints" )
util.AddNetworkString( "wOS.SkillTree.ResetPlayerSkills" )

net.Receive( "wOS.SkillTree.AddXP", function( len, ply )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	local steamid = net.ReadString()
	local number = net.ReadInt( 32 )
	local target
	for _, PLAYER in pairs( player.GetAll() ) do
		if PLAYER:SteamID64() == steamid then
			target = PLAYER
			break
		end
	end
	
	if not target then return end
	if not target:IsValid() then return end
	
	target:AddSkillXP( number )
end )

net.Receive( "wOS.SkillTree.AddLevel", function( len, ply )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	local steamid = net.ReadString()
	local number = net.ReadInt( 32 )
	local target
	for _, PLAYER in pairs( player.GetAll() ) do
		if PLAYER:SteamID64() == steamid then
			target = PLAYER
			break
		end
	end
	
	if not target then return end
	if not target:IsValid() then return end
	
	target:SetSkillLevel( target:GetSkillLevel() + number )
end )

net.Receive( "wOS.SkillTree.AddSkillPoints", function( len, ply )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	local steamid = net.ReadString()
	local number = net.ReadInt( 32 )
	local target
	for _, PLAYER in pairs( player.GetAll() ) do
		if PLAYER:SteamID64() == steamid then
			target = PLAYER
			break
		end
	end
	
	if not target then return end
	if not target:IsValid() then return end
	
	target:AddSkillPoints( number )
end )

net.Receive( "wOS.SkillTree.SetXP", function( len, ply )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	local steamid = net.ReadString()
	local number = net.ReadInt( 32 )
	local target
	for _, PLAYER in pairs( player.GetAll() ) do
		if PLAYER:SteamID64() == steamid then
			target = PLAYER
			break
		end
	end
	
	if not target then return end
	if not target:IsValid() then return end
	
	target:SetSkillXP( number )
end )

net.Receive( "wOS.SkillTree.SetLevel", function( len, ply )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	local steamid = net.ReadString()
	local number = net.ReadInt( 32 )
	local target
	for _, PLAYER in pairs( player.GetAll() ) do
		if PLAYER:SteamID64() == steamid then
			target = PLAYER
			break
		end
	end
	
	if not target then return end
	if not target:IsValid() then return end
	
	target:SetSkillLevel( number )
	target:SetSkillXP( wOS.XPScaleFormula( target:GetSkillLevel() - 1 ) )
end )

net.Receive( "wOS.SkillTree.SetSkillPoints", function( len, ply )
	if not wOS.AdminSettings.CanAccessMenu[ ply:GetUserGroup() ] then return end
	local steamid = net.ReadString()
	local number = net.ReadInt( 32 )
	local target
	for _, PLAYER in pairs( player.GetAll() ) do
		if PLAYER:SteamID64() == steamid then
			target = PLAYER
			break
		end
	end
	
	if not target then return end
	if not target:IsValid() then return end
	
	target:SetSkillPoints( number )
end )

net.Receive( "wOS.SkillTree.ResetPlayerSkills", function( len, admin )

	if not wOS.AdminSettings.CanAccessMenu[ admin:GetUserGroup() ] then return end

	local steamid = net.ReadString()
	local ply = player.GetBySteamID64( steamid ) 
	if not IsValid( ply ) then return end

	for name, _ in pairs( wOS.SkillTrees ) do
		ply.SkillTree[ name ] = {}
		ply.EquippedSkills[ name ] = {}
	end
	ply:SetSkillLevel( 0 )
	ply:SetSkillPoints( 0 )
	ply:SetSkillXP( 0 )

	wOS.SkillDatabase:SaveData( ply )
	wOS:TransmitSkillData( ply )
	ply:KillSilent()
	
end )