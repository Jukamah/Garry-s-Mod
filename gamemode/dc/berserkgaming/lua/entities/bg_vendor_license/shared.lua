ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
 
ENT.PrintName		= "License Vendor"
ENT.Author			= "Valaskair"
ENT.Contact			= "http://www.steamcommunity.com/id/am-zeus"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable		= true
ENT.AdminSpawnable 	= true
ENT.Category		= "Berserk Gaming"

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end