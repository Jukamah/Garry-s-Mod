AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel(VBGMODELS["Stock.Monitor"])
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
    net.Start("V.BG.Stock.Menu")
		local indexStocks = caller:bgGetPlayerStocks()
		local indexStringA = table.concat(indexStocks, "\n")
		
		local indexTableA = bgGetStocks()
		local indexTableB = {}
		
		for k, v in pairs(indexTableA) do
			local indexTableC = string.Explode("‼", v)
		
			table.insert(indexTableB, k, table.concat({ indexTableC[2], indexTableC[3] }, "‼"))
		end
		
		local indexStringB = table.concat(indexTableB, "\n")
		
		net.WriteString(indexStringA)
		net.WriteString(indexStringB)
	net.Send(caller)
end
 
function ENT:Think()

end
 