AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel(VBGMODELS["Blueprint"])
	if VBGMODELS["Blueprint"] == "models/hunter/plates/plate025x05.mdl" then
		self:SetMaterial("models/props_c17/paper01")
	end
	self:PhysicsInit(SOLID_VPHYSICS) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetUseType(SIMPLE_USE)
	
	local indexKey = math.random(1, VBGBPCHECK)
	local indexTable = VBGBP[indexKey][1]
	self:SetNWString("V.BG.BP.Name", indexTable[1])
	self:SetNWString("V.BG.BP.Class", indexTable[2])
	
	self:SetNWInt("V.BG.BP.Key", indexKey)
end
 
function ENT:Use(activator, caller)
	net.Start("V.BG.Blueprint.Pickup")
		net.WriteInt(self:GetNWInt("V.BG.BP.Key"), 32)
		net.WriteString(table.concat(caller:bgGetBlueprints(), "\n"))
		net.WriteEntity(self)
	net.Send(caller)
end
 
function ENT:Think()

end
 