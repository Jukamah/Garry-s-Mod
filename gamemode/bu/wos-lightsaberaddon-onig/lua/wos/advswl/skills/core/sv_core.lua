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
wOS.SkillTrees = wOS.SkillTrees or {}
wOS.TransmitableSkillTrees = {}

local meta = FindMetaTable( "Player" )

---SET FUNCTIONS

function meta:SetSkillPoints( amt )
	self:SetNW2Int( "wOS.SkillPoints", amt )
end

function meta:SetSkillLevel( amt )
	self:SetNW2Int( "wOS.SkillLevel", amt )
end

function meta:SetSkillXP( amt )
	self:SetNW2Int( "wOS.SkillExperience", amt )
end

---ADD FUNCTIONS

function meta:AddSkillXP( amt )
	if wOS.SkillMaxLevel then 
		if self:GetSkillLevel() >= wOS.SkillMaxLevel then 
			return
		end
	end
	if wOS.VrondrakisSync then
		self:addXP( amt )
	end
	self:SetSkillXP( self:GetSkillXP() + amt )
	self:CheckSkillLevel()
end

function meta:AddSkillPoints( amt )
	self:SetSkillPoints( self:GetSkillPoints() + amt )
end

---SKILL RELATED APPLICATIONS

function meta:CheckSkillLevel()

	local xp = self:GetSkillXP()
	local level = self:GetSkillLevel()
	local reqxp = wOS.XPScaleFormula( level )
	
	if reqxp <= xp then
		if wOS.SkillMaxLevel then 
			if level >= wOS.SkillMaxLevel then 
				return
			end
		end
		self:SkillLevelUp()
	end
	
end

function meta:SkillLevelUp()

	self:SetSkillLevel( self:GetSkillLevel() + 1 )
	self:SendLua( [[ surface.PlaySound( "buttons/button24.wav" ) ]] )
	self:SendLua( [[ notification.AddLegacy( "[wOS] Congratulations! Your Combat Level is now ]] .. self:GetSkillLevel() .. [[", NOTIFY_GENERIC, 3 ) ]] )
	if self:GetSkillLevel() % wOS.LevelsPerSkillPoint == 0 then
		self:AddSkillPoints( wOS.SkillPointPerLevel )
		self:SendLua( [[ notification.AddLegacy( "[wOS] You've earned a skill point! Spend it at a Skill Station", NOTIFY_GENERIC, 3 ) ]] )
	end
	self:CheckSkillLevel()
	
end

function meta:SetCurrentSkillHooks()

	self.PlayerSkillSpawns = {}
	for name, _ in pairs( self.SkillTree ) do
		local sdata = wOS.SkillTrees[ name ]
		if sdata then
			if sdata.JobRestricted then
				local found = false
				for _, job in pairs( sdata.JobRestricted ) do
					if _G[ job ] == self:Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
			for skill, data in pairs( self.SkillTree[ name ] ) do
				if data.OnPlayerSpawn then
					self.PlayerSkillSpawns[ #self.PlayerSkillSpawns + 1 ] = data.OnPlayerSpawn
				end
			end
		end
	end
	
	self.PlayerSkillDeaths = {}
	for name, _ in pairs( self.SkillTree ) do
		local sdata = wOS.SkillTrees[ name ]
		if sdata then
			if sdata.JobRestricted then
				local found = false
				for _, job in pairs( sdata.JobRestricted ) do
					if _G[ job ] == self:Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
			for skill, data in pairs( self.SkillTree[ name ] ) do
				if data.OnPlayerDeath then
					self.PlayerSkillDeaths[ #self.PlayerSkillSpawns + 1 ] = data.OnPlayerDeath
				end
			end
		end
	end
	
	self.PlayerSaberDeploys = {}
	for name, _ in pairs( self.SkillTree ) do
		local sdata = wOS.SkillTrees[ name ]
		if sdata then
			if sdata.JobRestricted then
				local found = false
				for _, job in pairs( sdata.JobRestricted ) do
					if _G[ job ] == self:Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
			for skill, data in pairs( self.SkillTree[ name ] ) do
				if data.OnSaberDeploy then
					self.PlayerSaberDeploys[ #self.PlayerSaberDeploys + 1 ] = data.OnSaberDeploy
				end
			end
		end
	end
	
	self.PlayerSaberSlashes = {}
	for name, _ in pairs( self.SkillTree ) do
		local sdata = wOS.SkillTrees[ name ]
		if sdata then
			if sdata.JobRestricted then
				local found = false
				for _, job in pairs( sdata.JobRestricted ) do
					if _G[ job ] == self:Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
			for skill, data in pairs( self.SkillTree[ name ] ) do
				if data.OnSaberDamaged then
					self.PlayerSaberSlashes[ #self.PlayerSaberDeploys + 1 ] = data.OnSaberDamaged
				end
			end
		end
	end
	
	self.PlayerSaberBlocks = {}
	for name, _ in pairs( self.SkillTree ) do
		local sdata = wOS.SkillTrees[ name ]
		if sdata then
			if sdata.JobRestricted then
				local found = false
				for _, job in pairs( sdata.JobRestricted ) do
					if _G[ job ] == self:Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
			for skill, data in pairs( self.SkillTree[ name ] ) do
				if data.OnSaberBlocked then
					self.PlayerSaberBlocks[ #self.PlayerSaberBlocks + 1 ] = data.OnSaberBlocked
				end
			end
		end
	end
	
end

function wOS:RegisterSkillTree( DATA )

	self.SkillTrees[ DATA.Name ] = DATA
	
	resource.AddFile( "materials/" .. DATA.TreeIcon ) -- Auto resource add!
	
	local transfer = {}
	transfer.Name = DATA.Name
	transfer.Description = DATA.Description
	transfer.TreeIcon = DATA.TreeIcon
	transfer.BackgroundColor = DATA.BackgroundColor
	transfer.MaxTiers = DATA.MaxTiers
	transfer.UserGroups = DATA.UserGroups
	transfer.JobRestricted = DATA.JobRestricted
	transfer.Tier = {}
	for i, skills in pairs( DATA.Tier ) do
		transfer.Tier[ i ] = {}
		for slot, dat in pairs( skills ) do
			transfer.Tier[ i ][ slot ] = {}
			transfer.Tier[ i ][ slot ].Name = dat.Name
			transfer.Tier[ i ][ slot ].Description = dat.Description
			transfer.Tier[ i ][ slot ].Icon = dat.Icon
			
			resource.AddFile( "materials/" .. dat.Icon ) -- Auto resource add! Round TWO
			
			transfer.Tier[ i ][ slot ].PointsRequired = dat.PointsRequired
			transfer.Tier[ i ][ slot ].Requirements = dat.Requirements
		end
	end
	
	wOS.TransmitableSkillTrees[ DATA.Name ] = table.Copy( transfer )
	print( "[wOS] Successfully registered skill tree: " .. DATA.Name )
	
end

function wOS:GetSkillTreeData( tree )
	return self.SkillTrees[ tree ]
end

function wOS:TransmitSkillData( caller, ply )
	
	if not ply then ply = caller end
	
	net.Start( "wOS.SkillTree.SendPlayerData" )
		net.WriteTable( ply.EquippedSkills )
		net.WriteBool( ply == caller )
		net.WriteEntity( ply )
	net.Send( caller )
	
end

function wOS:TransmitSkillTrees( caller )

	if not caller then return end
	
	net.Start( "wOS.SkillTree.SendTrees" )
		net.WriteTable( wOS.TransmitableSkillTrees )
	net.Send( caller )
	
end

hook.Add( "PlayerSpawn", "wOS.SkillTree.ActivatePlayerSpawns", function( ply )

	if ply.AppliedSkills then return end
	if ply:IsBot() then return end
	timer.Create( "SkillApplication" .. ply:SteamID64(), 1, 0, function()
		if not IsValid( ply ) then
			timer.Destroy( "SkillApplication" .. ply:SteamID64() )
			return
		end
		if not ply.PlayerSkillSpawns then return end
		ply.CanUseDuals = false
		for _, spawn in pairs( ply.PlayerSkillSpawns ) do
			spawn( ply )
		end
		if ply:HasWeapon( "weapon_lightsaber_personal" ) and ply.CanUseDuals then
			ply:Give( "weapon_lightsaber_personal_dual" )
		end
		ply.AppliedSkills = true
		timer.Destroy( "SkillApplication" .. ply:SteamID64() )
	end )

end )


hook.Add( "OnPlayerChangedTeam", "wOS.SkillTree.DarkRPJobFix", function( ply, _, _ )
	
	ply:SetCurrentSkillHooks()
	ply.AppliedSkills = false
	
end )

hook.Add( "PlayerDeath", "wOS.SkillTree.ActivatePlayerDeaths", function( ply, wep, att )

	if !ply:IsBot() then
		for _, death in pairs( ply.PlayerSkillDeaths ) do
			death( ply )
		end
		ply.AppliedSkills = false
	end
	
	if not att:IsPlayer() then return end	
	if att == ply then return end
	
	local usergroup = att:GetUserGroup()
	local xp = wOS.ExperienceTable[ "Default" ].PlayerKill
		
	if wOS.ExperienceTable[ usergroup ] then
		xp = wOS.ExperienceTable[ usergroup ].PlayerKill
	end
	
	att:AddSkillXP( xp )

	if IsValid( att:GetActiveWeapon() ) then
		if att:GetActiveWeapon().IsLightsaber then
			if att:GetActiveWeapon().PersonalLightsaber then
				xp = wOS.SaberExperienceTable[ "Default" ].PlayerKill
				if wOS.SaberExperienceTable[ usergroup ] then
					xp = wOS.SaberExperienceTable[ usergroup ].PlayerKill
				end	
				att:AddSaberXP( xp )
				if att:GetActiveWeapon().SaberXPMul > 0 then
					att:AddSaberXP( xp*att:GetActiveWeapon().SaberXPMul )			
				end
			end
		end
	end
	
end )

hook.Add( "OnNPCKilled", "wOS.SkillTree.ActivateNPCDeaths", function( npc, att, wep )

	if not att:IsPlayer() then return end	
	
	local usergroup = att:GetUserGroup()
	local xp = wOS.ExperienceTable[ "Default" ].NPCKill
		
	if wOS.ExperienceTable[ usergroup ] then
		xp = wOS.ExperienceTable[ usergroup ].NPCKill
	end	
	
	att:AddSkillXP( xp )
	
	if IsValid( att:GetActiveWeapon() ) then
		if att:GetActiveWeapon().IsLightsaber then
			xp = wOS.SaberExperienceTable[ "Default" ].PlayerKill
			if wOS.SaberExperienceTable[ usergroup ] then
				xp = wOS.SaberExperienceTable[ usergroup ].PlayerKill
			end	
			att:AddSaberXP( xp )
		end
	end
	
end )

if wOS.TimeBetweenXP then
	timer.Create( "wOS.SkillTree.XPInterval", wOS.TimeBetweenXP, 0, function()
		for _, ply in pairs( player.GetAll() ) do
			if not ply.SkillTree then continue end
			local tbl = wOS.ExperienceTable[ ply:GetUserGroup() ]
			if not tbl then tbl = wOS.ExperienceTable[ "Default" ] end
			ply:AddSkillXP( tbl.XPPerInt )
		end
	end )
end