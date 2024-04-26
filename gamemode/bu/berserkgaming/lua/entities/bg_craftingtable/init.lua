AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel(VBGCRAFTINGTABLEMODEL)
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
    net.Start("V.BG.Crafting.Menu")
		local indexTable = caller:bgGetBlueprints()
		local indexString = table.concat(indexTable, "\n")
		
		net.WriteString(indexString)
		net.WriteString(table.concat(caller:bgGetInventory(), "\n"))
	net.Send(caller)
end
 
function ENT:Think()

end
 