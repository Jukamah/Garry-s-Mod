AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

local Config  = {
	// models/generic/ammocrate2.mdl
	["model"] = "models/Items/ammoCrate_Rockets.mdl",
	
	// How much to set the armour (per job)
	["armour"] = {
		[TEAM_CITIZEN] = 100,
	},
		
	// How much to set the hp (per job)
	["hp"] = {
		[TEAM_CITIZEN] = 100,
	},

	// How much of each ammo type to give to player
	["ammo.primary"] = 1000,
	["ammo.secondary"] = 50,
	
	["ui"] = false,
}

function ENT:Initialize()
	self:SetModel("models/generic/ammocrate2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetUseType(SIMPLE_USE)
end
 
function ENT:Use(activator, caller)
	if Config["ui"] then
		net.Start("BlackoutRP.Armoury.Menu")
		net.Send(caller)
	else
		local indexJobKey = tonumber(caller:getJobTable().team)
		local indexWeapons = caller:getJobTable().weapons
		local indexAmmo = {}
		
		for _, weaponClass in pairs(indexWeapons) do
			table.insert(indexAmmo, {
				weapons.GetStored(weaponClass).Primary.Ammo,
				weapons.GetStored(weaponClass).Secondary.Ammo,
			})
			
			caller:Give(weaponClass)
		end
		
		for k, v in pairs(indexAmmo) do
			caller:GiveAmmo(Config["ammo.primary"], v[1])
			caller:GiveAmmo(Config["ammo.secondary"], v[2])
		end
		
		local isJobIncluded = false
		for k, v in pairs(Config["armour"]) do
			if k == indexJobKey then
				isJobIncluded = true
			end
		end
		
		if isJobIncluded then
			caller:SetHealth(Config["hp"][indexJobKey])
			caller:SetArmor(Config["armour"][indexJobKey])
		else
			caller:SetHealth(100)
			caller:SetArmor(0)
		end
	end
end
 
function ENT:Think()

end
 