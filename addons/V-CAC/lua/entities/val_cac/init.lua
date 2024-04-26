AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')

ModelID = "models/Items/ammocrate_ar2.mdl"
Ammo = {}
Ammo[1] = "smg1"
Ammo[2] = "ar2"
Ammo[3] = "pistol"
AmmoCount = (table.Count(Ammo))

AmmoAmount = {}
AmmoAmount[1] = 5
AmmoAmount[2] = 10
AmmoAmount[3] = 15
 
function ENT:Initialize()
	self:SetModel(ModelID)
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
	for i = 1, AmmoCount do
		activator:GiveAmmo(AmmoAmount[i], Ammo[i])
	end
    return
end

function ENT:Think()

end