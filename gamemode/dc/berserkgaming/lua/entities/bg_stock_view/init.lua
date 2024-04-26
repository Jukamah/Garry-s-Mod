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
	self:SetNWInt("Multiplier", 1)
	
	self:SetNWString("Text", "")
end
 
function ENT:Use(activator, caller)
	if table.HasValue(VBGCONFIGEDIT, caller:GetNWString("usergroup")) then
		net.Start("V.BG.Stock.Menu.Edit")
			net.WriteEntity(self)
		net.Send(caller)
	end
end
 
function ENT:Think()
	local indexStocks = bgGetStocks()
	local indexTable = {}
	
	for k, v in pairs(indexStocks) do
		local Stock = string.Explode("‼", v)
		local Name = Stock[1]
		local Dev = Stock[4] or 0
		
		local indexString = table.concat({ Name, math.Round(tonumber(Dev), 4) }, " ")
		if indexTable[k] != indexString then
			table.remove(indexTable, k)
			table.insert(indexTable, k, indexString)
		end
	end
	
	if self:GetNWString("Text") != table.concat(indexTable, " | ") then
		self:SetNWString("Text", table.concat(indexTable, " | "))
	end
end
 