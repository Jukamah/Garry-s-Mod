if SERVER then
	AddCSLuaFile("autorun/FoHUD.lua")

	local folderList = {}
	folderList = file.Find("autorun/".."*.lua", "LUA")
	table.sort(folderList)
	for _, f in pairs(folderList) do
		AddCSLuaFile("autorun/" .. f)
	end

	local files, directories = file.Find( "materials/hud/fo/".."*", "GAME" )
 	table.sort(files)

	for k,v in pairs(files) do
		resource.AddFile("materials/hud/fo"..v)
	end
end

hook.Add("PlayerSpawn","GetPLYCollor",function(ply)
	ply:SetNWVector("hudColor", Vector(ply:GetWeaponColor().x * 255,ply:GetWeaponColor().y * 255,ply:GetWeaponColor().z * 255))
end)

if CLIENT then
	if (!ConVarExists("fh_on")) then
		CreateConVar("fh_on", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
	end

	trace = ErrorNoHalt

	local hideComponents = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
		["CHudAmmo"] = true,
		["CHudCrosshair"] = true,
		["CHudDamageIndicator"] = true,
		["CHudSecondaryAmmo"] = true,
		["CHudCrosshair"] = true
	}

	local function HUDShouldDraw(name)
		if (hideComponents[name] && GetConVar("fh_on"):GetInt() >= 1) then
			return false;
		end

	end
	hook.Add("HUDShouldDraw", "HUDDisabler", HUDShouldDraw)
	
	local function showPlayerInfo()
		local pos = self:EyePos()

		pos.z = pos.z + 10
		pos = pos:ToScreen()

		local nick, plyTeam = self:Nick(), self:Team()
		draw.DrawNonParsedText(nick, "Default", pos.x + 1, pos.y + 1, colors.black, 1)
		draw.DrawNonParsedText(nick, "Default", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam) , 1)

		local health = DarkRP.getPhrase("health", self:Health())
		draw.DrawNonParsedText(health, "Default", pos.x + 1, pos.y + 21, colors.black, 1)
		draw.DrawNonParsedText(health, "Default", pos.x, pos.y + 20, colors.white1, 1)

		local teamname = self:getDarkRPVar("job") or team.GetName(self:Team())
		draw.DrawNonParsedText(teamname, "Default", pos.x + 1, pos.y + 41, colors.black, 1)
		draw.DrawNonParsedText(teamname, "Default", pos.x, pos.y + 40, colors.white1, 1)
	end

	function PlayerName()
		for k, ply in pairs(players or player.GetAll()) do
			if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then continue end
			local hisPos = ply:GetShootPos()

			if hisPos:DistToSqr(shootPos) < 160000 then
				local pos = hisPos - shootPos
				local unitPos = pos:GetNormalized()
				if unitPos:Dot(aimVec) > 0.95 then
					local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
					if trace.Hit and trace.Entity ~= ply then return end
					ply:drawPlayerInfo()
				end
			end
		end
	end
	hook.Add("HUDPaint", "ShowPlayerInfo", PlayerName)
end

hook.Add("PlayerSpawn","SetAttributes",function(ply)
	ply:SetNWInt("AP",100)
end)
