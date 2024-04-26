AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel(VBGMODELS["Stock.View"])
	self:PhysicsInit(SOLID_VPHYSICS) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetUseType(SIMPLE_USE)
	
	self:SetNWInt("Width", 1000)
	self:SetNWInt("Height", 250)
	self:SetNWString("Text", "Hello World!§Wha§wha")
	self:SetNWBool("AutoFill", true)
end
 
function ENT:Use(activator, caller)
    net.Start("V.BG.Sign.Edit")
		net.WriteEntity(self)
	net.Send(caller)
end
 
function ENT:Think()

end
 