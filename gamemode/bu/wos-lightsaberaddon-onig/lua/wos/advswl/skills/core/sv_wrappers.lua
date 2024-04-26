
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
wOS.SkillDatabase = wOS.SkillDatabase or {}
local TableToSkill = {}
local SkillToTable = {}

local DATA

if wOS.ShouldSkillUseMySQL then
	require('mysqloo')
	DATA = mysqloo.CreateDatabase( wOS.SkillDatabase.Host, wOS.SkillDatabase.Username, wOS.SkillDatabase.Password, wOS.SkillDatabase.Database, wOS.SkillDatabase.Port, wOS.SkillDatabase.Socket )
	if not DATA then
		print( "[wOS] MySQL Database connection failed. Falling back to PlayerData" )
		wOS.ShouldSkillUseMySQL = false
	else
		print( "[wOS] Skill Tree MySQL connection was successful!" )	
	end
end

local MYSQL_COLUMNS_GENERAL = "( SteamID varchar(255), Level int, Experience bigint, SkillPoints int )"
local MYSQL_COLUMNS_SKILLTREE = "( SteamID varchar(255), CurrentSkills varchar(255) )"

function wOS.SkillDatabase:Initialize()
	
	if DATA then
		local TRANS = DATA:CreateTransaction()
		TRANS:Query( "CREATE TABLE IF NOT EXISTS leveldata " .. MYSQL_COLUMNS_GENERAL )
		TRANS:Start(function(transaction, status, err)
			if (!status) then error(err) end
			local CTRANS = DATA:CreateTransaction()
			for name, _ in pairs( wOS.SkillTrees ) do
				local tablename = string.Replace( name, " ", "-" )
				TableToSkill[ tablename ] = name
				SkillToTable[ name ] = tablename
				CTRANS:Query( "CREATE TABLE IF NOT EXISTS `" .. DATA:escape( tablename ) .. "` " .. MYSQL_COLUMNS_SKILLTREE )
			end
			CTRANS:Start(function(transaction, status, err)
			if (!status) then error(err) end end )
		end)
	else
		if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
		if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
		if not file.Exists( "wos/advswl/skills", "DATA" ) then file.CreateDir( "wos/advswl/skills" ) end
		if not file.Exists( "wos/advswl/leveling", "DATA" ) then file.CreateDir( "wos/advswl/leveling" ) end
		for name, _ in pairs( wOS.SkillTrees ) do
			if not file.Exists( "wos/advswl/skills/" .. name, "DATA" ) then file.CreateDir( "wos/advswl/skills/" .. name ) end
		end		
	end
	
end

function wOS.SkillDatabase:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	ply.EquippedSkills = {}	
	ply.SkillTree = {}	
	
	if DATA then
	
		local TRANS = DATA:CreateTransaction()		
		TRANS:Query( "SELECT * FROM leveldata WHERE SteamID = '" .. steam64 .. "'" )
		local skill_trans = {}
		local index = 1
		for name, _ in pairs( wOS.SkillTrees ) do
			index = index + 1
			TRANS:Query( "SELECT CurrentSkills FROM `" .. DATA:escape( SkillToTable[ name ] ) .. "` WHERE SteamID = '" .. steam64 .. "'" )
			skill_trans[ index ] = name
		end
		TRANS:Start(function(transaction, status, err)
			if (!status) then error(err) end
			
			local queries = transaction:getQueries()
			local C_TRANS = DATA:CreateTransaction()	
			local leveldata = queries[1]:getData()
			if table.Count( leveldata ) < 1 then
				creation_needed = true
				C_TRANS:Query( "INSERT INTO leveldata ( SteamID, Level, Experience, SkillPoints ) VALUES ( '" .. steam64 .. "','"  .. 0 .. "','" .. 0 .. "','" .. 0 .. "')" )
			else
				leveldata = leveldata[1]
				ply:SetSkillLevel( leveldata.Level )
				ply:SetSkillXP( leveldata.Experience )
				ply:SetSkillPoints( leveldata.SkillPoints )
			end
			
			local creation_needed = false
			for i = 2, index do
				local skilldata = queries[i]:getData()
				local name = skill_trans[ i ]
				if table.Count( skilldata ) < 1 then
					creation_needed = true
					C_TRANS:Query( "INSERT INTO `" .. DATA:escape( SkillToTable[ name ] ) .. "` ( SteamID, CurrentSkills ) VALUES ( '" .. steam64 .. "','')" )	
				else
					skilldata = skilldata[1]
					local treedata = wOS:GetSkillTreeData( name )
					local skills = string.Explode( ";", skilldata.CurrentSkills )
					local flag = false
					local total = 0
					if treedata.UserGroups then
						if not table.HasValue( treedata.UserGroups, ply:GetUserGroup() ) then 
							flag = true
						end
					end
					for _, readdata in pairs( skills ) do
						local data = string.Explode( ",", readdata )
						local tier = tonumber( data[1] )
						local skill = tonumber( data[2] )
						if not treedata.Tier[ tier ] then continue end
						local skilldata = treedata.Tier[ tier ][ skill ]
						if not skilldata then continue end
						if flag then
							if skilldata.PointsRequired then 
								total = total + skilldata.PointsRequired
							end
							continue
						end
						if not ply.EquippedSkills[ name ] then ply.EquippedSkills[ name ] = {} end
						if not ply.EquippedSkills[ name ][ tier ] then ply.EquippedSkills[ name ][ tier ] = {} end
						ply.EquippedSkills[ name ][ tier ][ skill ] = true
						if not ply.SkillTree[ name ] then ply.SkillTree[ name ] = {} end
						ply.SkillTree[ name ][ skilldata.Name ] = skilldata
					end
					if flag then
						ply:AddSkillPoints( total )
					end
				end
			end
			if creation_needed then
				C_TRANS:Start(function(transaction, status, err) end)
			end
			wOS:TransmitSkillData( ply )
			ply:SetCurrentSkillHooks()
		end)
		
	else
	
		local read = file.Read( "wos/advswl/leveling/" .. steam64 .. ".txt", "DATA" )	
		if not read then			
			local data = { Level = 0, Experience = 0, SkillPoints = 0 }
			data = util.TableToJSON( data )
			file.Write( "wos/advswl/leveling/" .. steam64 .. ".txt", data )	
		else
			local readdata = util.JSONToTable( read )
			ply:SetSkillLevel( readdata.Level )
			ply:SetSkillXP( readdata.Experience )
			ply:SetSkillPoints( readdata.SkillPoints )	
		end
		for name, _ in pairs( wOS.SkillTrees ) do
			ply.SkillTree[ name ] = {}
			ply.EquippedSkills[ name ] = {}
			local read = file.Read( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. ".txt", "DATA" )
			if not read then 
				local data = {}
				data = util.TableToJSON( data )
				file.Write( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. ".txt", data )
			else
				local treedata = wOS:GetSkillTreeData( name )
				if not treedata then continue end
				treedata = treedata.Tier
				if not treedata then continue end
				local flag = false
				local total = 0
				if treedata.UserGroups then
					if not table.HasValue( treedata.UserGroups, ply:GetUserGroup() ) then 
						flag = true
					end
				end
				local readdata = util.JSONToTable( read )
				for tier, skills in pairs( readdata ) do
					if not treedata[ tier ] then continue end
					if flag then
						local skilldata = treedata[ tier ][ skill ]
						if skilldata.PointsRequired then 
							total = total + skilldata.PointsRequired
						end
						continue
					end
					if not ply.EquippedSkills[ name ] then ply.EquippedSkills[ name ] = {} end
					if not ply.EquippedSkills[ name ][ tier ] then ply.EquippedSkills[ name ][ tier ] = {} end
					for skill, _ in pairs( skills ) do
						local skilldata = treedata[ tier ][ skill ]
						if not skilldata then continue end
						ply.EquippedSkills[ name ][ tier ][ skill ] = true
						ply.SkillTree[ name ][ skilldata.Name ] = skilldata
					end
				end
				if flag then
					ply:AddSkillPoints( total )
				end
			end
		end		
		
		ply:SetCurrentSkillHooks()
		wOS:TransmitSkillData( ply )
		
	end
	
	wOS:TransmitSkillTrees( ply )
	
end

function wOS.SkillDatabase:SaveData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.EquippedSkills then return end
	if not ply.SkillTree then return end
	if DATA then
		local builddata = {}
		for name, tierdata in pairs( ply.EquippedSkills ) do
			builddata[ name ] = ""
			for tier, skilldata in pairs( tierdata ) do
				for skill, _ in pairs( skilldata ) do
					builddata[ name ] = builddata[ name ] .. tier .. "," .. skill .. ";"
				end
			end
		end
		local TRANS = DATA:CreateTransaction()		
		TRANS:Query( "UPDATE leveldata SET Level = " .. ply:GetSkillLevel() .. ", Experience = " .. ply:GetSkillXP() .. ", SkillPoints = " .. ply:GetSkillPoints() .. " WHERE SteamID = " .. steam64 )
		for name, _ in pairs( wOS.SkillTrees ) do
			if builddata[ name ] then
				TRANS:Query( "UPDATE `" .. DATA:escape( SkillToTable[ name ] ) .. "` SET CurrentSkills = '" .. builddata[ name ] .. "' WHERE SteamID = " .. steam64 )
			end
		end
		TRANS:Start(function(transaction, status, err)
			if (!status) then error(err) end
		end)
		
	else
		
		local data = {}
		data.Level = ply:GetSkillLevel()
		data.Experience = ply:GetSkillXP()
		data.SkillPoints = ply:GetSkillPoints()
		
		data = util.TableToJSON( data )
		file.Write( "wos/advswl/leveling/" .. steam64 .. ".txt", data )			
		for name, _ in pairs( wOS.SkillTrees ) do
			local savedata = table.Copy( ply.EquippedSkills[ name ] ) or {}
			savedata = util.TableToJSON( savedata )
			file.Write( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. ".txt", savedata )
		end			
		
	end

end


hook.Add( "PlayerInitialSpawn", "wOS.SkillTree.SkillLoading", function( ply )
	wOS.SkillDatabase:LoadData( ply )
end )

hook.Add( "PlayerDisconnected", "wOS.SkillTree.SkillSaving", function( ply )
	wOS.SkillDatabase:SaveData( ply )
end )

timer.Create( "wOS.SkillTree.AutoSave", wOS.SkillDatabase.SaveFrequency, 0, function() 
	for _, ply in pairs ( player.GetAll() ) do
		wOS.SkillDatabase:SaveData( ply )
	end
end )

wOS.SkillDatabase:Initialize()