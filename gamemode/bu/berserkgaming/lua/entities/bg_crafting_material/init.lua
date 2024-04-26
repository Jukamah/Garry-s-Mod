AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	local rng = math.random(1, #VBGMATERIALS)
	self:SetModel(VBGMATERIALS[rng][3])
	self:PhysicsInit(SOLID_VPHYSICS) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetUseType(SIMPLE_USE)
	
	self:SetNWString("V.BG.Key", VBGMATERIALS[rng][1])
	self:SetNWString("V.BG.Rarity", VBGMATERIALS[rng][4])
end
 
function ENT:Use(activator, caller)
	caller:bgAddItem({ 1, self:GetNWString("V.BG.Key"), self:GetNWString("V.BG.Rarity") })
	self:Remove()
end
 
function ENT:Think()

end
 